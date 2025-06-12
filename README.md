# Linux Setup Scripts

A collection of automated setup scripts for various Linux distributions to streamline the installation and configuration of essential tools and packages.

## 🐧 Supported Distributions

- **Arch Linux** - Complete setup with AUR support
- **Ubuntu** - Multiple versions (20.04, 22.04, 24.04)
- **Manjaro** - Feature-rich setup with customizations

## 📁 Repository Structure

```
scripts/
├── arch/
│   ├── arch.sh                     # Main Arch Linux setup script
│   ├── grub.sh                     # GRUB configuration script
│   └── Matrices-circle-window/     # Custom window configurations
├── ubuntu/
│   ├── Ubuntu_20.sh                # Ubuntu 20.04 setup script
│   ├── Ubuntu_22.sh                # Ubuntu 22.04 setup script
│   └── Ubuntu_24.sh                # Ubuntu 24.04 setup script
└── manjaro/
    ├── Manjaro_24.sh               # Manjaro 24 setup script
    ├── rise_config                 # Rise configuration
    ├── run.txt                     # Run instructions
    └── Stylish/                    # Custom styling configurations
```

## 🚀 Features

### Arch Linux Setup (`arch/arch.sh`)
- **System Updates**: Automated system updates with keyring management
- **Package Installation**: Essential packages via pacman and AUR (yay)
- **Development Tools**: VSCode, Git, Python, Java, and more
- **Media & Productivity**: VLC, LibreOffice, OBS Studio, Spotify
- **System Configuration**: Bluetooth, printer support, touchpad settings
- **Cleanup**: Orphan removal and package cache cleaning

**Key Packages Included:**
- Development: `gdb`, `vim`, `python`, `jdk-openjdk`, `git`
- Media: `vlc`, `obs-studio`, `ffmpeg`, `spotify`
- Productivity: `libreoffice-still`, `texlive`, `texstudio`
- System Tools: `htop`, `tree`, `fastfetch`, `ranger`
- Graphics: `nitrogen`, `picom`, `flameshot`

### Ubuntu Setup Scripts
- **Multiple Versions**: Support for Ubuntu 20.04, 22.04, and 24.04
- **Snap & APT**: Mixed package management approach
- **Essential Tools**: Chrome, VSCode, Slack, Discord, development tools
- **Python Environment**: Python 3 with pip and virtual environment support
- **System Cleanup**: Automatic cleanup and maintenance

### Manjaro Setup
- **Comprehensive Setup**: Full desktop environment configuration
- **Custom Styling**: Personalized themes and configurations
- **Performance Optimization**: System tuning and optimizations

## 📋 Prerequisites

- Fresh installation of supported Linux distribution
- Root/sudo access
- Internet connection
- Git (for cloning the repository)

## 🛠️ Usage

### Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ayyzenn/scripts.git
   cd scripts
   ```

2. **Make scripts executable:**
   ```bash
   chmod +x arch/arch.sh
   chmod +x ubuntu/Ubuntu_*.sh
   chmod +x manjaro/Manjaro_*.sh
   ```

3. **Run the appropriate script:**

   **For Arch Linux:**
   ```bash
   cd arch
   ./arch.sh
   ```

   **For Ubuntu:**
   ```bash
   cd ubuntu
   ./Ubuntu_24.sh  # or Ubuntu_20.sh, Ubuntu_22.sh
   ```

   **For Manjaro:**
   ```bash
   cd manjaro
   ./Manjaro_24.sh
   ```

## ⚙️ Configuration

### Customizing Package Lists

You can modify the package lists in each script before running:

**Arch Linux (`arch/arch.sh`):**
- Edit `PACMAN_PACKAGES` array for official repository packages
- Edit `AUR_PACKAGES` array for AUR packages

**Ubuntu Scripts:**
- Modify the `install_all_tools()` function to add/remove packages

### Delay Configuration

The Arch script includes a configurable delay between installations:
```bash
DELAY=1  # Delay in seconds
```

## 🔧 Special Features

### Arch Linux Advanced Features
- **PGP Key Management**: Automatic handling of signature issues
- **Printer Configuration**: Automated CUPS and Samba printer setup
- **Bluetooth Support**: Complete Bluetooth stack installation
- **Touchpad Configuration**: Natural scrolling and gesture support

### Error Handling
- Failed package installations are logged to `failed_packages.log`
- Robust error recovery mechanisms
- System validation checks

## 📝 Logs

Installation failures are automatically logged:
- Check `failed_packages.log` for any packages that failed to install
- Review terminal output for detailed installation progress

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on a fresh VM/installation
5. Submit a pull request

## ⚠️ Disclaimer

- **Backup Important Data**: Always backup your system before running setup scripts
- **Review Scripts**: Examine scripts before execution to understand what will be installed
- **Test Environment**: Consider testing in a virtual machine first
- **System Changes**: These scripts make significant system modifications

## 📞 Support

If you encounter issues:
1. Check the logs for error messages
2. Verify your internet connection
3. Ensure you have sufficient disk space
4. Open an issue with detailed error information

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Note**: These scripts are designed for personal use and may need customization for your specific needs. Always review and understand what a script does before running it on your system.