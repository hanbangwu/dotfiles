#!/usr/bin/env fish

set HOMEBREW_PREFIX (brew --prefix)

function configure
    for item in $argv
        switch $item
            case arduino
                brew install arduino-cli
                brew install --cask arduino-ide
                arduino-cli config init
            case git
                brew install gh git
                git config --global init.defaultBranch main
            case kitty
                brew install --cask font-cascadia-mono-nf kitty
                ln -fs $HOME/projects/dotfiles/kitty $HOME/.config/kitty
            case neovim
                brew install fd fzf imagemagick luarocks neovim ripgrep tree-sitter-cli
                ln -fs $HOME/projects/dotfiles/nvim $HOME/.config/nvim
        end
    end
end

function configure_language
    for language in $argv
        switch $language
            case cpp # and c
                brew install cmake llvm
            case go
                brew install go
            case java
                brew install openjdk
            case javascript # and typescript
                brew install biome bun node pnpm yarn
            case python
                brew install uv
                uv python install 3.11
            case rust
                brew install rustup
                rustup default stable
                rustup component add rustfmt
                mkdir -p ~/.config/fish/completions
                rustup completions fish >~/.config/fish/completions/rustup.fish
                fish_add_path $HOME/.cargo/bin
            case tex
                brew install mactex-no-gui tex-fmt
        end
    end
end

# softwareupdate --install-rosetta --agree-to-license

fish_add_path $HOMEBREW_PREFIX/bin

brew install gum

type -q gum; or brew install gum

set tools (gum choose --no-limit \
    --header "Select tools to install:" \
    arduino git kitty neovim)

set languages (gum choose --no-limit \
    --header "Select languages to install:" \
    cpp go java javascript python rust tex)

test -n "$tools"; and configure $tools
test -n "$languages"; and configure_language $languages
