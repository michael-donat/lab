set DOTFILES (realpath (dirname (status --current-filename))/../..)
set -gx STARSHIP_CONFIG $DOTFILES/starship.toml

function e
    kc $argv[1]
    gc $argv[1]
end

source "$(brew --prefix)/share/google-cloud-sdk/path.fish.inc"
set -x GOPATH $HOME/go
set -x GOROOT "$(brew --prefix golang)/libexec"
set PATH $GOPATH/bin $GOROOT/bin $PATH

alias mm="go run mongo-mirror.go --config-file=/Users/mikey/.mongo-mirror/config.dev.toml"

if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
end

if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

set -x REDPANDA_BROKERS redpanda-broker.lab.donat.im:9092
