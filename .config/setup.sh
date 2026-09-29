#!/bin/env sh

# Use zsh
chsh -s $(which zsh)

# To install oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# To install chezmoi
# sh -c "$(curl -fsLS get.chezmoi.io)"

# Good font (arch)
# ttf-nerd-fonts-symbols

if [[ ! $(grep '#load_dot_conf_zsh' ~/.zshrc) ]]; then
echo 'Include ~/.config/zsh/* in .zshrc'
echo '
# Include zsh configuration: #load_dot_conf_zsh
for file in ~/.config/zsh/*; do source "$file"; done' >> ~/.zshrc
fi
