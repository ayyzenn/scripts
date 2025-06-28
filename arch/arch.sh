#!/bin/bash

# Configurable delay between installations
DELAY=1  # Delay in seconds

# List of packages to install via pacman
PACMAN_PACKAGES=(
    "gnome-disk-utility" "gdb" "tree" "qbittorrent" "net-tools" "noto-fonts-emoji"
    "openssh" "fastfetch" "vim" "vlc" "hugo" "tmux" "jdk-openjdk" "python"
    "python-virtualenv" "python-pip" "texlive" "texstudio" "cmatrix" "fortune-mod"
    "cowsay" "linux-headers" "ntfs-3g" "exfatprogs" "ranger" "alacritty"
    "nitrogen" "rsync" "sysstat" "acpi" "htop" "eog" "rtkit"
    "xorg-xev" "unzip" "zip" "evince" "libreoffice-still" "arandr" "bluez" "bluez-utils"
    "pipewire-pulse" "wireplumber" "gnome-calculator" "samba" "smbclient" "os-prober" "pavucontrol"
    "ttf-dejavu" "ttf-liberation" "noto-fonts" "xorg-xinput" "brightnessctl" "picom"
    "trash-cli" "ueberzug" "less" "alsa-utils" "pulsemixer" "dunst" "dos2unix" "flameshot" "reflector"
    "obs-studio" "ffmpeg" "intel-media-driver" "libva-intel-driver" "libva-utils" "noto-fonts-cjk" "nodejs"
    "npm" "materia-gtk-theme" "lxappearance" "plastic" "plastic_tui" "numlockx" "clang" 
)

# List of packages to install via yay (AUR)
AUR_PACKAGES=(
    "google-chrome" "visual-studio-code-bin" "slack-desktop" "spotify"
    "localsend-bin" "i3lock-color" "bibata-cursor-theme" "ttf-iosevka-nerd" "xidlehook"
    "cursor-bin" "github-cli"
)

# Function to check if a package is installed
is_installed() {
    pacman -Q "$1" &> /dev/null
}

# Function to handle PGP signature issues and refresh the keyring
refresh_keyring_and_update() {
    echo -e "\n\e[1;33mRefreshing keyring and updating the system...\e[0m"

    # Update keyring before system update
    sudo pacman -Sy --noconfirm archlinux-keyring
    sudo pacman-key --init
    sudo pacman-key --populate archlinux

    echo -e "\e[1;34mRefreshing keys (this may take a moment)...\e[0m"

    # Set a timeout for key refresh to prevent long hangs
    if ! timeout 5 sudo pacman-key --refresh-keys; then
        echo -e "\e[1;31mKey refresh timed out or failed.\e[0m"
    fi

    # Proceed with full system update
    sudo pacman -Syu --noconfirm

    echo -e "\e[1;32mSystem refresh completed successfully!\e[0m"
    echo -e "\n###########################################\n"
    sleep $DELAY
}

# Function to update the system and handle errors
update_system() {
    echo -e "\n\e[1;34mUpdating the system...\e[0m"

    if ! sudo pacman -Syu --noconfirm; then
        echo -e "\e[1;31mError during system update. Attempting to resolve PGP signature issues...\e[0m"
        refresh_keyring_and_update
    else
        echo -e "\e[1;32mSystem update completed successfully!\e[0m"
    fi

    echo -e "\n###########################################\n"
    sleep $DELAY
}

# Function to install packages via pacman
install_pacman_packages() {
    echo -e "\e[1;34mInstalling essential pacman packages...\e[0m"
    for package in "${PACMAN_PACKAGES[@]}"; do
        if ! is_installed "$package"; then
            echo -e "\e[1;34mInstalling $package...\e[0m"
            sudo pacman -S --noconfirm "$package" || echo "$package installation failed" >> failed_packages.log

        else
            echo -e "\e[1;32m$package is already installed. Skipping.\e[0m"
        fi
        echo -e "\n###########################################\n"
        sleep $DELAY
    done
}

# Function to install yay and AUR packages
install_yay_and_aur() {
    echo -e "\e[1;34mInstalling yay AUR helper...\e[0m"
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay-bin.git "$HOME/yay-bin"
    cd "$HOME/yay-bin" || exit 1
    makepkg -si --noconfirm
    cd "$HOME" && rm -rf "$HOME/yay-bin"

    for package in "${AUR_PACKAGES[@]}"; do
        if ! is_installed "$package"; then
            echo -e "\e[1;34mInstalling $package from AUR...\e[0m"
            yay -S --noconfirm "$package" || echo "$package installation failed" >> failed_packages.log
        else
            echo -e "\e[1;32m$package is already installed. Skipping.\e[0m"
        fi
        echo -e "\n###########################################\n"
        sleep $DELAY
    done
}

# Function to handle Conda installations
install_conda_tools() {
    if command -v conda &> /dev/null; then
        echo -e "\e[1;34mAnaconda is installed. Updating and managing dependencies...\e[0m"
        conda update -y conda
        conda install -y -c conda-forge pandoc
        conda update -y --all
        conda clean -y --all
        echo -e "\e[1;32mAnaconda-related operations completed.\e[0m"
        echo -e "\n###########################################\n"
    else
        echo -e "\e[1;31mAnaconda is not installed. Please install it manually.\e[0m"
        echo -e "\n###########################################\n"
    fi
    sleep $DELAY
}

# Function to install and configure printer support
configure_printer() {
    echo -e "\e[1;34mInstalling necessary packages...\e[0m"
    sudo pacman -S --noconfirm cups cups-filters cups-pdf samba smbclient gutenprint ghostscript

    echo -e "\e[1;34mEnabling and starting necessary services...\e[0m"
    sudo systemctl enable --now cups smb nmb

    if grep -q "workgroup = WORKGROUP" /etc/samba/smb.conf; then
        echo -e "\e[1;32mSamba configuration already exists. Skipping.\e[0m"
    else
        echo -e "\e[1;34mConfiguring Samba...\e[0m"
        echo -e "\n[global]\nworkgroup = WORKGROUP\nsecurity = user\nclient min protocol = SMB2\nclient max protocol = SMB3" | sudo tee -a /etc/samba/smb.conf
        sudo systemctl restart smb nmb
        echo -e "\e[1;32mSamba configuration completed successfully!\e[0m"
    fi

    echo -e "\e[1;34mAdding printer...\e[0m"
    lpadmin -p Tearoom_Printer -E -v smb://pshfast/saad.ahmad:saad321@192.168.1.147/tearoom -m drv:///sample.drv/generpcl.ppd
    sudo systemctl restart cups

    echo -e "\e[1;34mSetting default printer...\e[0m"
    lpoptions -d Tearoom_Printer

    echo -e "\n###########################################\n"
    sleep $DELAY
}

# Function to install Bluetooth support
bluetooth_support() {
    echo -e "\n\e[1;34mInstalling Bluetooth support...\e[0m"
    sudo systemctl enable --now bluetooth.service
    sudo usermod -aG lp $USER
    echo -e "\e[1;32mBluetooth support installed successfully!\e[0m"
    echo -e "\n###########################################\n"
    sleep $DELAY
}

# Function to remove orphaned dependencies
remove_orphans() {
    if sudo pacman -Qtdq &>/dev/null; then
        echo -e "\e[1;34mRemoving orphaned dependencies...\e[0m"
        sudo pacman -Rns $(pacman -Qtdq) --noconfirm
    else
        echo -e "\e[1;32mNo orphaned dependencies found.\e[0m"
    fi
}

# Function to clean package cache
clean_package_cache() {
    echo -e "\e[1;34mCleaning package cache...\e[0m"
    sudo pacman -Sc --noconfirm
}


# Function to enable natural scrolling for touchpad
touchpad_natural_scrolling() {

    CONFIG_DIR="/etc/X11/xorg.conf.d"
    CONFIG_FILE="$CONFIG_DIR/30-touchpad.conf"

    # Ensure the directory exists
    sudo mkdir -p "$CONFIG_DIR"

    # Write the touchpad configuration
    echo "Creating or updating $CONFIG_FILE to enable natural scrolling..."
    sudo bash -c 'cat > '"$CONFIG_FILE"' <<EOL
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "tapping" "on"
    Option "AccelProfile" "adaptive"
    Option "TappingButtonMap" "lrm"
    Option "NaturalScrolling" "true"
EndSection
EOL'

    echo -e "\e[1;32mTouchpad natural scrolling enabled successfully!\e[0m"
    echo -e "\n###########################################\n"
    sleep $DELAY
}

# Function to set global cursor theme system-wide
set_cursor_theme() {
    local theme="$1"
    local size="${2:-24}"

    echo -e "\n\e[1;34mApplying system-wide cursor theme: $theme ($size px)...\e[0m"

    echo "Xcursor.theme: $theme" > ~/.Xresources
    echo "Xcursor.size: $size" >> ~/.Xresources
    xrdb -merge ~/.Xresources

    mkdir -p ~/.config/gtk-3.0
    cat > ~/.config/gtk-3.0/settings.ini <<EOF
[Settings]
gtk-theme-name=Materia-dark
gtk-cursor-theme-name=$theme
gtk-cursor-theme-size=$size
EOF

    echo "gtk-cursor-theme-name=\"$theme\"" > ~/.gtkrc-2.0

    if ! grep -q "xsetroot -cursor_name" ~/.config/i3/config; then
        echo "exec --no-startup-id xsetroot -cursor_name $theme" >> ~/.config/i3/config
    fi

    sudo bash -c "echo -e '[Icon Theme]\nInherits=$theme' > /usr/share/icons/default/index.theme"

    if ! grep -q "XCURSOR_THEME" ~/.profile; then
        echo "export XCURSOR_THEME=$theme" >> ~/.profile
        echo "export XCURSOR_SIZE=$size" >> ~/.profile
    fi

    echo -e "\e[1;32mCursor theme applied. Please reboot or restart Xorg for full effect.\e[0m"
    echo -e "\n###########################################\n"
    sleep $DELAY
}

# Function to setup the dotfiles
setup_dotfiles() {
    echo -e "\n\e[1;34mSetting up dotfiles...\e[0m"
    if [ -d "$HOME/dotfiles" ]; then
        echo -e "\e[1;32mDotfiles directory already exists. Skipping.\e[0m"
    else
        echo -e "\e[1;34mCloning dotfiles repository...\e[0m"
        if git clone https://github.com/ayyzenn/dotfiles.git "$HOME/dotfiles"; then
            echo -e "\e[1;32mDotfiles repository cloned successfully!\e[0m"
            
            # Save current directory and change to dotfiles directory
            if cd "$HOME/dotfiles"; then
                echo -e "\e[1;34mRunning dotfiles installation script...\e[0m"
                if [ -x "./install.sh" ]; then
                    if ./install.sh; then
                        echo -e "\e[1;32mDotfiles setup completed successfully!\e[0m"
                        cd - > /dev/null
                    else
                        echo -e "\e[1;31mDotfiles installation script failed!\e[0m"
                    fi
                else
                    echo -e "\e[1;31mInstall script not found or not executable!\e[0m"
                fi
                # Return to previous directory
                cd - > /dev/null
            else
                echo -e "\e[1;31mFailed to change to dotfiles directory!\e[0m"
            fi
        else
            echo -e "\e[1;31mFailed to clone dotfiles repository!\e[0m"
        fi
    fi
    echo -e "\n###########################################\n"
    sleep $DELAY
}
# Function to install all tools and apps
install_all_tools() {
    echo -e "\e[1;34mInstalling all essential tools and applications...\e[0m"

    update_system
    sudo pacman -R i3lock --noconfirm

    update_system
    install_pacman_packages
    install_yay_and_aur
    install_conda_tools
    configure_printer
    touchpad_natural_scrolling
    bluetooth_support
    remove_orphans
    clean_package_cache
    set_cursor_theme "Bibata-Modern-Classic" 24

    sudo systemctl enable --now rtkit-daemon
    systemctl --user restart pipewire wireplumber
    export DISPLAY=:0
    setup_dotfiles

    sudo cp ~/.vimrc /root/.vimrc
    
    echo -e "\e[1;32mAll tools and applications installed successfully!\e[0m"
    echo -e "\n###########################################\n"
}

# Function to display a theme and style
display_theme() {
    echo -e "\e[1;35m###############################\e[0m"
    echo -e "\e[1;35m Welcome to the Arch Setup \e[0m"
    echo -e "\e[1;35m###############################\e[0m"
}

# Main function to handle script execution
main() {
    clear
    display_theme

    echo -e "\n\e[1;32m1. Install All Tools\e[0m"
    echo -e "\e[1;32m0. Exit\e[0m"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            install_all_tools
            ;;
        0)
            echo -e "\e[1;36mGoodbye!\e[0m"
            exit 0
            ;;
        *)
            echo -e "\e[1;31mInvalid option, please try again.\e[0m"
            ;;
    esac

    read -p "Do you want to continue? (y/n): " continue_choice
    if [[ "$continue_choice" != "y" ]]; then
        echo -e "\e[1;36mGoodbye!\e[0m"
        exit 0
    else
        main
    fi
}

# Run the main function
main
