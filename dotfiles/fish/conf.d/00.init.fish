set DOTFILES (realpath (dirname (status --current-filename))/../..)
set -gx STARSHIP_CONFIG $DOTFILES/starship.toml