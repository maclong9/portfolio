---
title: My Development Environment Setup
description: Creating a development environment that sparks joy with modern tools, thoughtful automation, and comprehensive configuration.
published: April 11, 2025
---

Look, I've been down the rabbit hole of development environment configuration more times than I care to admit. You know how it goes - you see someone's sleek terminal setup on Twitter, spend three hours configuring something you'll never use, and somehow end up with a development environment that's slower than before.

But after years of this cycle, I think I've finally landed on something that works. My [dotfiles repo](https://github.com/maclong9/dots) is basically my insurance policy against ever having to set up a development machine from scratch again.

## The Philosophy

Here's the thing about development environments - they're not about showing off how many aliases you can cram into a configuration file. They're about removing friction from your daily workflow. My approach boils down to:

- **Actually useful stuff only**: If I haven't used it in three months, it's gone
- **One command setup**: Because future me will definitely forget how to install everything  
- **Document the weird choices**: Why did I configure this thing this way? Future me needs to know
- **Keep it modular**: I should be able to swap out my editor without breaking everything else

## Workstation

### 14" MacBook Pro, M3 Pro, 18GB RAM

The 14" MacBook Pro with M3 Pro is the cornerstone of my professional setup. It excels in web development, native application building, and occasional video editing. The M3 Pro delivers exceptional performance and efficiency, handling video rendering swiftly, often without triggering the cooling fans. The fans only kicked in once when maxing out graphics settings in *Lies of P*. I rely on the MacBook's built-in trackpad and keyboard for their precision and comfort, eliminating the need for external monitors or peripherals. The speakers also stand out, providing clear, immersive sound.

For personal productivity, Apple's Calendar, Notes, Mail, and Reminders apps keep me organized and focused without complexity.

## The Tools That Actually Matter

### Terminal: Ghostty

I switched to **Ghostty** after getting tired of terminals that either looked great but were slow, or were fast but looked like they were designed in 1995. Ghostty hits that sweet spot of being both performant and customizable:

```toml
# Font configuration for coding
font-family = "SFMono Nerd Font"  
font-size = 18

# Theme and appearance
theme = "vesper"  # Consistent with editor
background-opacity = 0.95
macos-option-as-alt = true

# Window behavior
resize-overlay = "never"
confirm-close-surface = false
quit-after-last-window-closed = false
```

**Zsh** is where the magic happens. I've got it tuned for speed because a slow shell prompt is one of those death-by-a-thousand-cuts things that'll drive you insane:

- **zoxide** for smart directory jumping (because typing out full paths is for masochists)
- Git status caching so my prompt doesn't lag in big repos
- Command timing that shames me when things take too long
- Thoughtful Git aliases for common workflows
- Auto environment management so I stop forgetting to set things

### Package Management: mise

I used to have this chaotic mess of Homebrew, nvm, rbenv, and whatever else for managing different tool versions. **mise** replaced all of that with one config file and actually works consistently:

```toml
[settings]
experimental = true
idiomatic_version_file_enable_tools = ["swift"]

[tools]
github-cli = 'latest'
harper-ls = 'latest'
helix = 'latest'
marksman = 'latest'
node = 'lts'
shellcheck = 'latest'
shfmt = 'latest'
zoxide = 'latest'
'spm:maclong9/list' = 'latest'
'npm:@anthropic-ai/claude-code' = 'latest'
'npm:@tailwindcss/language-server' = 'latest'
'npm:bash-language-server' = 'latest'
'npm:typescript' = 'latest'
'npm:typescript-language-server' = 'latest'
'npm:vscode-langservers-extracted' = 'latest'
"npm:wrangler" = "latest"
```

### Editor: Helix

I used Vim for many years and enjoyed the modal editing paradigm, but appreciated **Helix**'s discoverability and sensible defaults. Helix provides excellent LSP integration without requiring extensive configuration - modal editing that makes sense with built-in features that just work.

```toml
theme = "vesper"

[editor]
auto-completion = true
bufferline = "multiple"
completion-trigger-len = 1
cursorline = true
line-number = "relative"
true-color = true

[editor.auto-save]
after-delay.enable = true
after-delay.timeout = 5000

[editor.cursor-shape]
insert = "bar"
normal = "block"
select = "underline"

[editor.statusline]
left = ["mode", "spacer", "version-control", "file-name", "file-modification-indicator"]
right = ["diagnostics", "selections", "register", "position"]

[editor.lsp]
display-messages = true
display-inlay-hints = false

# Key bindings for familiar workflow
[keys.insert]
"C-[" = "normal_mode"
"C-a" = "goto_line_start"
"C-e" = "goto_line_end"
"C-n" = "move_line_down"
"C-p" = "move_line_up"

[keys.normal]
"C-h" = "jump_view_left"
"C-j" = "jump_view_down" 
"C-k" = "jump_view_up"
"C-l" = "jump_view_right"
```

My LSP setup provides comprehensive language support:

- **TypeScript/JavaScript**: Modern web development tooling
- **Swift**: Native iOS and macOS development with Xcode integration
- **Bash**: Shellcheck integration for script validation
- **CSS/HTML**: Complete styling and markup support
- **Markdown**: Harper for prose linting and formatting
- **JSON**: Schema validation and IntelliSense

### Runtime Environments

**Deno** is my go-to for TypeScript projects. Its emphasis on security, performance, and built-in tools—such as formatting, linting, and testing—streamlines development. I frequently pair Deno with the Fresh framework for modern web applications.

**Swift** for native development and CLI tools. The Swift Package Manager makes dependency management straightforward, and the language's performance characteristics make it excellent for command-line utilities.

## The Daily Workflow Stuff

### Git Configuration

My Git config includes useful aliases for common workflows and development tasks. The configuration focuses on signing commits, sensible defaults, and streamlined workflows:

```ini
[user]
    name = Mac Long
    email = hello@maclong.uk
    signingkey = key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGf...

[commit]
    gpgsign = true

[gpg]
    format = ssh

[core]
    editor = hx
    autocrlf = input
    excludesfile = ~/.config/git/ignore

[push]
    default = simple
    followTags = true

[pull]
    rebase = true

# Essential aliases
[alias]
    co = checkout
    br = branch
    ci = commit
    st = status
    hist = log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short
    fixup = commit --fixup
    squash = commit --squash
    ri = rebase --interactive
```

Supporting tools include:

- **GitHub CLI** (`gh`) for streamlined repository management and CI/CD operations
- **SSH Agent** integration for secure, automated authentication

## The One-Command Setup

Everything is designed so I can nuke my machine and be back up and running quickly:

```bash
curl -fsSL https://raw.githubusercontent.com/maclong9/dots/main/setup.sh | sh
```

This script handles all of this automatically:

1. **Checks what OS** I'm running and what's already installed
2. **Backs up existing configs** (learned this lesson the hard way)
3. **Installs mise** and lets it handle everything else
4. **Symlinks all the configs** to the right places
5. **Sets up SSH and Git signing** with secure key management
6. **Tests that everything actually works** (also learned this the hard way)

## Things I Learned the Hard Way

1. **Start simple** - that fancy config you found on GitHub probably doesn't work the way you think it does
2. **Document your weird choices** - you will definitely forget why you configured something that way
3. **Test on a fresh machine** - your dotfiles are useless if they only work on your already-configured laptop
4. **Version control everything** - seriously, everything
5. **Steal shamelessly** - other people's dotfiles are a goldmine of ideas you never would have thought of

## The Bottom Line

Look, I probably spent way too much time on this setup. Could I be just as productive with VS Code and the default terminal? Maybe. But there's something satisfying about having a development environment that feels truly _yours_. Every shortcut makes sense to you, every color is exactly where you expect it, and when something breaks, you actually understand why.

My complete setup lives in my [dotfiles repo](https://github.com/maclong9/dots) if you want to check it out. Fair warning: you'll probably want to understand what each piece does rather than just copying everything wholesale. But if any part of it makes your daily coding a little less frustrating, then it's done its job.

You can also read about [how I set up a new system](/posts/how-i-set-up-a-new-mac) for the step-by-step process.
