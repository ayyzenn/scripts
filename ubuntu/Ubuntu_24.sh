#!/bin/bash

# Function to install all the tools
install_all_tools() {
    # Update and upgrade the system
    sudo apt update && sudo apt upgrade -y
    sudo apt install smbclient -y

    # Remove unnecessary packages
    sudo snap remove firefox
    sudo snap remove thunderbird
    sudo apt-get purge -y transmission*

    # Install necessary packages
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    sudo snap install code --classic
    sudo snap install vlc
    sudo snap install slack --classic
    sudo snap install curl
    sudo snap install localsend
    sudo snap install discord
    sudo snap install spotify
    sudo snap install hugo
    
    sudo apt install -y gnome-tweaks synaptic build-essential gdb tree qbittorrent net-tools openssh-server openssh-client git neofetch xournal vim texlive-full texstudio openjdk-21-jdk cmatrix fortune-mod cowsay rsync

    # Install Python and related tools
    sudo apt-get install -y python3 python3-venv python3-pip

    # Clean up
    sudo apt autoremove -y
    sudo apt autoclean -y

    # Conda-related installations
    if command -v conda &> /dev/null; then
        conda update -y conda
        conda install -y -c conda-forge pandoc
        conda update -y --all
        conda clean -y --all
    fi
    echo "All tools have been installed successfully!"
}

# Main script loop
while true; do
    clear

    echo -e "This is my automation file to install all the tools I need on my Ubuntu 20.04.06 ;)\n"
    echo -e "1. Install All Tools"
    echo -e "0. Exit\n"

    read -p "Enter your choice: " choice

    case $choice in
        1) install_all_tools;;
        0) echo "Exiting..."; break;;
        *) echo "Invalid option, please try again.";;
    esac

    read -p "Do you want to continue? (y/n): " continue_choice
    if [[ $continue_choice != "y" ]]; then
        echo "Goodbye!"
        break
    fi
done

