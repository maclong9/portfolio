// Theme dropdown functionality - replaces Alpine.js theme dropdown
class ThemeDropdown {
    constructor() {
        this.isOpen = false;
        this.init();
    }

    init() {
        // Listen for dropdown toggle
        document.addEventListener('click', (e) => {
            const themeToggle = e.target.closest('[data-theme-toggle]');
            if (themeToggle) {
                e.preventDefault();
                this.toggle();
                return;
            }

            const themeOption = e.target.closest('[data-theme-option]');
            if (themeOption) {
                e.preventDefault();
                const theme = themeOption.dataset.themeOption;
                if (window.themeManager) {
                    window.themeManager.setTheme(theme);
                }
                this.updateUI();
                this.close();
                return;
            }

            // Close dropdown when clicking outside
            if (this.isOpen && !e.target.closest('.theme-dropdown')) {
                this.close();
            }
        });

        // Update UI initially and when theme changes
        this.updateUI();
        
        // Listen for theme changes
        const observer = new MutationObserver(() => {
            this.updateUI();
        });
        
        observer.observe(document.documentElement, {
            attributes: true,
            attributeFilter: ['data-theme']
        });
    }

    toggle() {
        if (this.isOpen) {
            this.close();
        } else {
            this.open();
        }
    }

    open() {
        this.isOpen = true;
        const dropdown = document.querySelector('.theme-dropdown-menu');
        if (dropdown) {
            dropdown.style.display = 'block';
            // Trigger reflow for animation
            dropdown.offsetHeight;
            dropdown.classList.add('theme-dropdown-menu--open');
        }
    }

    close() {
        this.isOpen = false;
        const dropdown = document.querySelector('.theme-dropdown-menu');
        if (dropdown) {
            dropdown.classList.remove('theme-dropdown-menu--open');
            setTimeout(() => {
                if (!this.isOpen) {
                    dropdown.style.display = 'none';
                }
            }, 150); // Match transition duration
        }
    }

    updateUI() {
        const themeManager = window.themeManager;
        if (!themeManager) return;

        const preference = themeManager.getThemePreference();
        
        // Update theme toggle button icon
        const toggleIcons = document.querySelectorAll('[data-theme-icon]');
        toggleIcons.forEach(icon => {
            icon.style.display = 'none';
        });
        
        const activeIcon = document.querySelector(`[data-theme-icon="${preference}"]`);
        if (activeIcon) {
            activeIcon.style.display = 'block';
        }

        // Update dropdown options
        const options = document.querySelectorAll('[data-theme-option]');
        options.forEach(option => {
            const isActive = option.dataset.themeOption === preference;
            option.classList.toggle('theme-option--active', isActive);
        });
    }
}

// Initialize theme dropdown globally
window.themeDropdown = new ThemeDropdown();