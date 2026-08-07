if status is-interactive
    # Commands to run in interactive sessions can go here
end

switch (uname)
    case Darwin
        set --export BUN_INSTALL "$HOME/.bun"
        set --export PATH $BUN_INSTALL/bin $PATH
        export PATH="$HOME/.local/bin:$PATH"
    case Linux
end
