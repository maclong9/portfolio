**Setting Up a New Mac **

  


**This guide outlines my streamlined process for configuring a new macOS system with modern development tools and automated setup. ******

  


I've been down the rabbit hole of Mac setup more times than I care to admit. What started as a manual, multi-hour process has evolved into a streamlined system that gets me back to productive development in minutes rather than hours.

  


**The Philosophy******

  


My approach to Mac setup is built around three core principles:

  


  * **One command to rule them all**: I should be able to nuke my machine and be productive again with a single command
  * **Automation over documentation**: Scripts don't forget steps or make typos
  * **Modern tooling**: Use contemporary tools that solve problems better than legacy solutions

  


**The One-Command Setup******

  


Everything is designed so I can get back up and running quickly:

  


curl -fsSL https://raw.githubusercontent.com/maclong9/dots/main/setup.sh | sh

  


  


This single command handles the entire setup process, but let me break down what's happening behind the scenes.

  


**Migration Assistant (Optional)******

  


Apple provides [Migration Assistant](https://support.apple.com/en-us/102613) to facilitate the transfer of documents, applications, user accounts, and settings from an old Mac to a new one. This saves significant time by eliminating the need to manually edit settings and re-download applications.

  


However, I often prefer a clean installation approach, especially when upgrading major macOS versions or switching between different Mac models.

  


**Modern Development Environment Setup******

  


**Package Management with mise******

  


The biggest game-changer in my setup is using [mise](https://mise.jdx.dev/) for managing all development tools and languages. Gone are the days of juggling Homebrew, nvm, rbenv, and various other version managers.

  


# ~/.config/mise/config.toml

[settings]

experimental = true

idiomatic_version_file_enable_tools = ["swift"]

  


[tools]

github-cli = 'latest'

helix = 'latest'

node = 'lts'

shellcheck = 'latest'

shfmt = 'latest'

zoxide = 'latest'

'spm:maclong9/list' = 'latest'

'npm:@tailwindcss/language-server' = 'latest'

'npm:typescript' = 'latest'

'npm:wrangler' = 'latest'

  


  


This single configuration file manages everything from Node.js and TypeScript to my custom Swift tools and language servers.

  


**Dotfiles Architecture******

  


My [dotfiles repo](https://github.com/maclong9/dots) uses a modular approach:

  


# Clone dotfiles to ~/.config

git clone https://github.com/maclong9/dots ~/.config

  


# Symlink configuration files

ln -sf ~/.config/zsh/.zshrc ~/.zshrc

ln -sf ~/.config/git/config ~/.gitconfig

ln -sf ~/.config/helix/config.toml ~/.config/helix/config.toml

  


  


The setup script automatically handles:

  * Backing up existing configurations
  * Creating necessary directories
  * Symlinking all configuration files
  * Setting appropriate permissions

  


**SSH and Git Security******

  


Modern Git security with SSH commit signing:

  


# Generate SSH key for GitHub

ssh-keygen -t ed25519 -C "hello@maclong.uk" -f ~/.ssh/id_ed25519 -N ""

  


# Configure SSH agent

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_ed25519

  


# Set up Git signing

git config --global user.signingkey "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGf..."

git config --global commit.gpgsign true

git config --global gpg.format ssh

  


  


**Terminal Environment******

  


**Ghostty** as the terminal emulator provides excellent performance with modern features:

  


# Font and appearance

font-family = "SFMono Nerd Font"

font-size = 18

theme = "vesper"

background-opacity = 0.95

  


# macOS integration

macos-option-as-alt = true

quit-after-last-window-closed = false

  


  


**Zsh** configuration focuses on speed and productivity:

  * **zoxide** for intelligent directory navigation
  * Git status caching for large repositories
  * Command timing and performance monitoring
  * Thoughtful aliases for common workflows

  


**macOS System Configuration******

  


The setup script handles macOS-specific optimizations:

  


**Touch ID for sudo******

  


# Enable Touch ID for sudo commands

if [ "$(uname -s)" = "Darwin" ]; then

    sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local

    sudo sed -i '' '3s/^#//' /etc/pam.d/sudo_local

fi

  


  


**Xcode Command Line Tools******

  


# Install developer tools

if ! xcode-select -p >/dev/null 2>&1; then

    xcode-select --install

    # Wait for installation to complete

    until xcode-select -p >/dev/null 2>&1; do

        sleep 5

    done

fi

  


# Accept Xcode license

if ! /usr/bin/xcrun clang >/dev/null 2>&1; then

    sudo xcodebuild -license accept

fi

  


  


**System Preferences******

  


Rather than using individual defaults commands, the setup leverages preference files and plists for consistent configuration:

  


  * Optimized dock settings (auto-hide, position, size)
  * Finder preferences (show hidden files, extensions)
  * Trackpad and keyboard settings
  * Energy and display preferences

  


**Testing and Validation******

  


The setup script includes comprehensive testing to ensure everything works correctly:

  


# Verify installations

command -v hx >/dev/null 2>&1 || { echo "Helix installation failed"; exit 1; }

command -v zoxide >/dev/null 2>&1 || { echo "zoxide installation failed"; exit 1; }

command -v gh >/dev/null 2>&1 || { echo "GitHub CLI installation failed"; exit 1; }

  


# Test Git signing

git config --get commit.gpgsign | grep -q "true" || { echo "Git signing not enabled"; exit 1; }

  


# Verify SSH agent

ssh-add -l >/dev/null 2>&1 || { echo "SSH key not loaded"; exit 1; }

  


  


**Continuous Maintenance******

  


Keeping everything current is straightforward:

  


# Update all tools and languages

mise upgrade

  


# Update dotfiles

cd ~/.config && git pull

  


# Update system and App Store apps

softwareupdate -ia

mas upgrade

  


  


A weekly maintenance script runs automatically to handle routine updates and cleanup.

  


**Modern Tool Highlights******

  


**Essential Command Line Tools******

  


  * **[Helix**](https://helix-editor.com/): Modern modal editor with excellent LSP integration
  * **[zoxide**](https://github.com/ajeetdsouza/zoxide): Intelligent directory navigation
  * **[GitHub CLI**](https://cli.github.com/): Streamlined Git workflow management
  * **[mise**](https://mise.jdx.dev/): Universal tool version manager

  


**Development Languages and Runtimes******

  


  * **Swift**: For CLI tools and native macOS development
  * **Deno**: Modern TypeScript runtime with built-in tooling
  * **Node.js LTS**: For traditional JavaScript projects

  


**LSP and Language Support******

  


The setup includes comprehensive language server support:

  * TypeScript/JavaScript with advanced type checking
  * Swift with Xcode integration
  * Bash with ShellCheck validation
  * CSS/HTML with TailwindCSS integration
  * Markdown with prose linting

  


**Lessons Learned******

  


After years of iteration, here's what I've learned about Mac setup:

  


  1. **Automate everything**: Manual steps will be forgotten or executed incorrectly
  2. **Test on fresh machines**: Your setup script is worthless if it only works on your already-configured system
  3. **Use modern tools**: Don't cling to legacy solutions when better alternatives exist
  4. **Document the weird stuff**: Future you will thank present you for explaining unusual configuration choices
  5. **Version control is non-negotiable**: Everything should be in Git, always

  


**The Complete Picture******

  


This setup creates a development environment that's:

  * **Reproducible**: The same configuration works across different machines and macOS versions
  * **Maintainable**: Updates and changes are centralized and automated
  * **Fast**: Modern tools with performance optimizations throughout
  * **Comprehensive**: Everything needed for full-stack development in one setup

  


You can explore my complete configuration and setup scripts at [github.com/maclong9/dots](https://github.com/maclong9/dots). For a deeper dive into the specific tools and configurations, check out my detailed post on [development environment setup](/posts/my-personal-setup).

  


The investment in creating this automated setup has paid dividends in reduced friction and increased productivity. When your development environment is one command away, you can focus on building great software instead of fighting with tooling.
