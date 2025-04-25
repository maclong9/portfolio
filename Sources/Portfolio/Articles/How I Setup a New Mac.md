---
title: How I Setup a New Mac
description: A walkthrough of the process of configuring a new macOS system.
published: April 25, 2025
---

## Running Migration Assistant

Apple conveniently provide this tool to allow you to migrate all of your documents, apps, user accounts and settings from your old Mac to the new one. This saves me a whole bunch of time from writing a script that manually edits all of the settings using the `defaults` command and also from spending time clicking around the App Store.

## Configuring Development Tools

This used to be a tedious process however I wrote a lovely little POSIX shell script that will clone my dotfiles to `~/.config` and symbolically link the relevant files for `zsh`, `git` and `vim` to my home directory.

 ```sh
# Clone Configuration Files and Symlink to Home Directory
git clone https://github.com/maclong9/dots .config
for file in .config/.*; do
	case "$(basename "$file")" in
		"." | ".." | ".git") continue ;;
		*) ln -s "$file" "$HOME/$(basename "$file")" ;;
	esac
done
```

A few other things the script does include configuring my ssh keys: 

 ```sh
 ssh-keygen -t ed25519 -C "maclong9@icloud.com" -f "$HOME/.ssh/id_ed25519" -N ""
eval "$(ssh-agent -s)"
mkdir ~/.ssh
printf 'Host github.com\n\tAddKeysToAgent yes\n\tIdentityFile ~/.ssh/id_ed25519' > ~/.ssh/config
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub | pbcopy
```

Enabling Touch ID for allowing `sudo` commands in the terminal, installing Xcode developer tooling if it's missing:

 ```sh
 # Check If Running on macOS
if [ "$(uname -s)" = "Darwin" ]; then
	# Enable Touch ID for `sudo`
	sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
	sudo sed -i '' '3s/^#//' /etc/pam.d/sudo_local

	# Install Developer Tools
	! xcode-select -p >/dev/null 2>&1 && xcode-select --install
	! /usr/bin/xcrun clang >/dev/null 2>&1 && sudo xcodebuild -license accept
fi
```

 Installing any extra tools I need, at the time of writing this list includes [Swift List](https://github.com/maclong9/list) a simple recreation of the UNIX `ls` command written in Swift and [Deno](https://deno.com) as I work on a fair amount of TypeScript projects for my job and have been using Deno as a full replacement for node.js and npm:

 ```sh
 # Install Swift List
sudo mkdir /usr/local/bin
sudo curl -L https://github.com/maclong9/list/releases/download/v1.1.2/sls -o /usr/local/bin/sls
sudo chmod +x /usr/local/bin/sls

# Deno
curl -fsSL https://deno.land/install.sh | sh;
```

 You can view my full configuration and script [here](https://github.com/maclong9/dots).

 Once these two steps are done I can go back to working as if nothing changed and I am still running on my old laptop just with the updated macOS and MacBook features.
