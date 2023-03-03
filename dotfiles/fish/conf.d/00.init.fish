set DOTFILES (realpath (dirname (status --current-filename))/../..)
set -gx STARSHIP_CONFIG $DOTFILES/starship.toml

function e
    kc $argv[1]
    gc $argv[1]
end