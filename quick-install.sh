#!/bin/bash

# This script is to install cloudflare-toolbox and it's dependancies automatically

main() {
    # Detecting the distribution
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        case $ID in
            ubuntu|debian)
                choice=1
                ;;
            arch|archarm|manjaro)
                choice=2
                ;;
            fedora|rhel|centos|rocky|almalinux|fedora-asahi-remix)
                choice=3
                ;;
            *)
                echo "Unsupported distribution. Exiting..."
                exit 1
                ;;
        esac
    else
        echo "OS release file (/etc/os-release) not found. Exiting..."
        exit 1
    fi

	#packages:
	packages_d="bash curl openssl jq" # Debian packages
	packages_a="bash curl openssl jq" # Arch packages
	packages_r="bash curl openssl jq" # Rhel/Fedora packages

# Define funcs

# For Arch-based distros:
# Prefer yay over paru over pacman (yay > paru > pacman)
# Use yay if installed, otherwise paru, or fallback to pacman.

install_arch_packages() {
    if command -v yay &>/dev/null; then
        yay -Syu --noconfirm bash curl openssl jq
    elif command -v paru &>/dev/null; then
        paru -Syu --noconfirm bash curl openssl jq
    else
        sudo pacman -Syu --noconfirm bash curl openssl jq
    fi
}

# For Debian-based distros:
# Prefer apt-fast over apt (apt-fast > apt)
# Use apt-fast if installed, otherwise fallback to apt.

install_cftb() {

    cd /tmp
    git clone https://codeberg.org/firebadnofire/cloudflare-toolbox cftb
    cd cftb
    sudo make reinstall
    cd ..
    rm -rf cftb
}

install_debian_packages() {
    if command -v apt-fast &>/dev/null; then
        sudo apt-fast update && sudo apt-fast install -y bash curl openssl jq
    else
        sudo apt update && sudo apt install -y bash curl openssl jq
    fi
}

    case $choice in
        1)
	    install_debian_packages
	    install_cftb
	    exit 0
            ;;
        2)
	    install_arch_packages
            install_cftb
            exit 0
            ;;
        3)
	    sudo dnf -y install $packages_d
            install_cftb
	    exit 0
            ;;
        e|E)
            echo "Exiting..."
            cd ~
            break
            ;;
        *)
            echo "Invalid selection. Please choose a number from 1 to 10, or 'e' to exit."
            ;;
        esac

}

# Execute the main function
main
