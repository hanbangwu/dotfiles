function maintain
    set platform (uname)

    switch $platform
        case Darwin
            brew update
            brew upgrade -g
        case Linux
            sudo apt-get update
            sudo apt-get upgrade -y
        case '*'
            echo "Unsupported OS: $platform"
    end
end
