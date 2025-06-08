#!/bin/bash

# Function to install all tools
install_all_tools() {
    # Update and upgrade the system
    sudo apt update -y && sudo apt upgrade -y

    # Remove unnecessary packages
    sudo apt remove -y firefox
    sudo apt-get purge -y thunderbird* transmission*

    # Install necessary packages
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    sudo snap install code --classic
    sudo snap install vlc
    sudo snap install slack --classic
    sudo snap install curl
    sudo snap install office365webdesktop --beta
    sudo apt install -y gnome-tweaks synaptic build-essential gdb tree qbittorrent net-tools openssh-server openssh-client git neofetch xournal grub-customizer texlive-full texstudio vim

    # Install LocalSend via snap
    sudo snap install localsend

    # Install Java
    wget https://download.oracle.com/java/23/latest/jdk-23_linux-x64_bin.deb
    sudo apt install -y ./jdk-23_linux-x64_bin.deb
    sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-23/bin/java 1
    sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-23/bin/javac 1

    # Install Python and related tools
    sudo apt-get install -y python3 python3-venv python3-pip

    # Install additional development libraries
    sudo apt install -y libglu1-mesa-dev freeglut3-dev mesa-common-dev

    # Install Intel OpenCL and Level Zero packages
    sudo apt install -y gpg-agent wget
    wget -qO - https://repositories.intel.com/graphics/intel-graphics.key | sudo apt-key add -
    sudo apt-add-repository 'deb [arch=amd64] https://repositories.intel.com/graphics/ubuntu focal main'
    sudo apt update
    sudo apt install -y intel-opencl-icd intel-level-zero-gpu level-zero intel-media-va-driver-non-free libmfx1

    # Install Wi-Fi drivers from GitHub
    git clone https://github.com/lwfinger/rtw89.git
    cd rtw89/
    sudo make -j$(nproc)
    sudo make install
    cd ..
    rm -rf rtw89/

    git clone https://github.com/HRex39/rtl8852be_bt
    cd rtl8852be_bt/
    sudo make -j$(nproc)
    sudo make install
    cd ..
    rm -rf rtl8852be_bt/

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

    # Install LibreOffice via snap
    sudo snap install libreoffice

    echo "All tools have been installed successfully!"
}

# Function for Minikube installation (placeholder)
install_minikube() {
    echo -e "Minikube installation is currently not implemented.\n"
}

# Main script loop
while true; do
    clear

    echo -e "This is my automation file to install all the tools I need on my Ubuntu 20.04.06 ;)\n"
    echo -e "1. Install All Tools"
    echo -e "2. Install Minikube"
    echo -e "0. Exit\n"

    read -p "Enter your choice: " choice

    case $choice in
        1) install_all_tools;;
        2) install_minikube;;
        0) echo "Exiting..."; break;;
        *) echo "Invalid option, please try again.";;
    esac

    read -p "Do you want to continue? (y/n): " continue_choice
    if [[ $continue_choice != "y" ]]; then
        echo "Goodbye!"
        break
    fi
done

