#!/usr/bin/env fish

function configure
    for item in $argv
        switch $item
            case fish
                sudo apt-get install -y fish
                chsh -s (which fish)
                ln -s $HOME/projects/dotfiles/fish $HOME/.config/fish
            case git
                git config --global init.defaultBranch main
            case kitty
                configure nerd-fonts
                sudo apt-get install -y kitty
                ln -s $HOME/projects/dotfiles/kitty $HOME/.config/kitty
            case neovim
                configure nerd-fonts
                sudo apt-get install -y neovim
                ln -s $HOME/projects/dotfiles/nvim $HOME/.config/nvim
            case nerd-fonts
                mkdir -p $HOME/.cache/nerd-fonts
                pushd $HOME/.cache/nerd-fonts
                curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.tar.xz
                tar -xf CascadiaMono.tar.xz
                mkdir -p $HOME/.fonts
                cp *.ttf $HOME/.fonts
                popd
            case ssh
                sudo apt-get install -y openssh-server
                sudo systemctl enable ssh
                sudo systemctl start ssh
        end
    end
end

function configure_language
    for item in $argv
        switch $item
            case javascript
                sudo apt-get install -y nodejs npm
                curl -fsSL https://bun.sh/install | bash
            case latex
                sudo apt-get install texlive-full
            case python
                curl -LsSf https://astral.sh/uv/install.sh | sh
            case rust
                curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        end
    end
end

sudo apt-get update -y

sudo apt-get install curl git

# gum
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt-get update && sudo apt-get install gum

set tools (gum choose --no-limit \
    --header "Select tools to install:" \
    fish git kitty neovim nerd-fonts ssh)

set languages (gum choose --no-limit \
    --header "Select languages to install:" \
    javascript latex python rust)

test -n "$tools"; and configure $tools
test -n "$languages"; and configure_language $languages
