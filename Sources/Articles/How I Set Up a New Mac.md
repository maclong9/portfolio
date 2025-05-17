---
title: Setting Up a New Mac
description: This guide outlines the process of configuring a new macOS system.
published: April 25, 2025
---

## Running Migration Assistant

Apple provides [Migration Assistant](https://support.apple.com/en-us/102613) to facilitate the transfer of documents, applications, user accounts, and settings from an old Mac to a new one. This saves time by eliminating the need to manually edit settings using the `defaults` command and navigating the App Store.

## Configuring Development Tools

Previously, configuring development tools was a time-consuming process. However, I have developed a POSIX shell script that automates the cloning of dotfiles to `~/.config` and the symbolic linking of relevant files for `zsh`, `git`, and `vim` to my home directory.

```sh
# Clone Configuration Files and Symlink to Home Directory
git clone https://github.com/maclong9/dots .config
for file in .config/.*; do
	case “$(basename “$file”)” in
		“.” | “..” | “.git”) continue ;;
		*) ln -s “$file” “$HOME/$(basename “$file”)” ;;
	esac
done
```

The script also configures my SSH keys:

```sh
ssh-keygen -t ed25519 -C “maclong9@icloud.com” -f “$HOME/.ssh/id_ed25519” -N “”
eval “$(ssh-agent -s)”
mkdir ~/.ssh
printf ‘Host github.com\n\tAddKeysToAgent yes\n\tIdentityFile ~/.ssh/id_ed25519” > ~/.ssh/config
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub | pbcopy
```

**macOS Specific Set Up**

* Enabling Touch ID for `sudo` Commands in the Terminal 
* Installing Xcode Developer Tooling

```sh
# Check if running on macOS
if [ “$(uname -s)” = “Darwin” ]; then
    # Enable Touch ID for `sudo`
    sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
    sudo sed -i ‘’ ‘3s/^#//‘ /etc/pam.d/sudo_local

    # Install Developer Tools
    ! xcode-select -p >/dev/null 2>&1 && xcode-select —install
    ! /usr/bin/xcrun clang >/dev/null 2>&1 && sudo xcodebuild -license accept
fi
```

> `>/dev/null` is used to silence STDOUT and `2>&1` silences STDERR

**Installing Additional Tools**

At the time of writing, the following additional tools are required:

* [Swift List](https://github.com/maclong9/list): A simple recreation of the UNIX `ls` command written in Swift.
* [Deno](https://deno.com): A full replacement for Node.js and npm, suitable for my TypeScript projects.

```sh
 # Install Swift List
sudo mkdir /usr/local/bin
sudo curl -L https://github.com/maclong9/list/releases/download/v1.1.2/sls -o /usr/local/bin/sls
sudo chmod +x /usr/local/bin/sls

# Deno
curl -fsSL https://deno.land/install.sh | sh;
```

 You can view my full configuration and script [here](https://github.com/maclong9/dots) as well as a brief explanation of some of the tools I use and why [on this post](/articles/my-personal-setup).

Once these two steps are done I can go back to working as if nothing changed and I am still running on my old laptop just with the updated macOS and MacBook features.
