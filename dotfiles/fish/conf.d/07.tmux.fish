# Interactive tmux session manager in iTerm control mode.
#   ta            picker: preview panes, go (enter), kill (ctrl-x), detach clients (ctrl-d)
#   ta cc-eflux   go to that one directly
# `●` = a client is attached, `·` = detached.
# Enter does the right thing for where you are: from a plain prompt it `-CC attach`s;
# from inside a tmux session (e.g. an iTerm split, which is a tmux pane) it `switch-client`s,
# which retargets your current client to that session instead of nesting.
function ta --description 'tmux session manager: preview / switch / kill via fzf'
    set -l tab (printf '\t')
    set -l name

    if test (count $argv) -gt 0
        set name $argv[1]
    else
        set -l fmt "#{session_name}$tab#{?session_attached,●,·} #{session_windows}w  #{t:session_created}"
        set -l reload "reload(tmux list-sessions -F '$fmt' 2>/dev/null)"

        set -l sel (tmux list-sessions -F "$fmt" 2>/dev/null \
            | fzf --prompt='tmux ❯ ' --height=60% --reverse --ansi \
                  --delimiter="$tab" \
                  --preview='tmux list-windows -t {1} -F "  #{window_index}: #{window_name} (#{window_panes}p)"; echo; tmux capture-pane -ep -t {1}' \
                  --preview-window='right,58%' \
                  --header='enter: go   ctrl-x: kill   ctrl-d: detach clients' \
                  --bind="ctrl-x:execute-silent(tmux kill-session -t {1})+$reload" \
                  --bind="ctrl-d:execute-silent(tmux detach-client -s {1})+$reload")

        test -z "$sel"; and return
        set name (string split -f1 "$tab" -- $sel)
    end

    if set -q TMUX
        tmux switch-client -t $name
    else
        # `exec` so tmux replaces this shell: on detach the gateway tab closes
        # instead of lingering at a prompt. The session keeps running; rerun `ta`.
        exec tmux -CC attach -t $name
    end
end

# Join a tmux session with an independent window (grouped session), rendered inline
# in the current pane. No -CC on purpose: iTerm control mode spawns its own native
# windows instead of filling the current split, so plain tmux is what renders here.
# Shares the target's windows but keeps its own focus. Named <session>-side to kill later.
#   tas            pick a session
#   tas cc-eflux   join that one directly
function tas --description 'Join a tmux session inline with an independent window, via fzf picker'
    set -l name
    if test (count $argv) -gt 0
        set name $argv[1]
    else
        set name (tmux ls -F '#S' 2>/dev/null | fzf --prompt='tmux ❯ ' --height 40% --reverse)
    end
    test -z "$name"; and return
    tmux new-session -t $name -s $name-side
end
