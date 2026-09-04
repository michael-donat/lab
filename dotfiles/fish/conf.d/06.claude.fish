# Always run interactive Claude inside a `tmux -CC` session, so it survives
# detach and you can ssh in and reattach from anywhere. `-CC` = iTerm control
# mode (native tabs/panes). See ~/.tmux.conf.
function cl --wraps claude --description 'Run Claude inside a tmux -CC session'
    # Already inside tmux: don't nest, just run the real binary.
    if set -q TMUX
        command claude $argv
        return
    end

    # One-shots and subcommands shouldn't spawn a session.
    if test (count $argv) -gt 0
        switch $argv[1]
            case mcp config doctor update install setup-token plugin migrate-installer -p --print --version -v -h --help
                command claude $argv
                return
        end
    end

    # Directory we were launched from. Everything below pins the session to it.
    set -l cwd (pwd)

    # Memorable, unique session name from the project directory: cc-<dir>[-N].
    # tmux uses `.` and `:` as target separators (session:window.pane), so map any
    # char outside [A-Za-z0-9_-] to a dash, collapse repeats, and trim the ends.
    # e.g. technology.road.io -> cc-technology-road-io.
    set -l dir (basename $cwd | string replace -ra '[^A-Za-z0-9_-]' '-' \
        | string replace -ra -- '-+' '-' | string trim -c -)
    set -l base "cc-$dir"
    set -l name $base
    set -l i 2
    while tmux has-session -t "=$name" 2>/dev/null
        set name "$base-$i"
        set i (math $i + 1)
    end

    # tmux execs `claude` directly (not via this fish function), so no recursion.
    #
    # `-c $cwd` sets the session's default directory (used for new panes/windows),
    # but tmux does NOT reliably apply it to the *launched command* when a server
    # is already running: the command inherits the active client session's
    # directory instead, silently dropping Claude into the wrong repo. So we also
    # `cd $cwd` inside the launched command itself. `$0` is $cwd, `$@` is $argv.
    #
    # `exec` so tmux replaces this shell: on detach the gateway tab closes instead
    # of lingering at a prompt. The tmux session keeps running; reattach with `ta`.
    exec tmux -CC new-session -s $name -c $cwd \
        sh -c 'cd "$0" && exec claude "$@"' $cwd $argv
end
