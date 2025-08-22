// Theme management functionality - replaces Alpine.js themeManager
class ThemeManager {
    constructor() {
        this.themePreference = localStorage.getItem('theme') || 'system';
        this.currentTheme = 'light';
        this.init();
    }

    setTheme(theme) {
        this.themePreference = theme;
        localStorage.setItem('theme', theme);
        this.updateTheme();
    }

    updateTheme() {
        let actualTheme = 'light';

        if (this.themePreference === 'dark') {
            actualTheme = 'dark';
        } else if (this.themePreference === 'system') {
            actualTheme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
        }

        this.currentTheme = actualTheme;
        document.documentElement.setAttribute('data-theme', actualTheme);
    }

    init() {
        this.updateTheme();

        // Listen for system theme changes when in system mode
        window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
            if (this.themePreference === 'system') {
                this.updateTheme();
            }
        });
    }

    // Get current theme preference for UI updates
    getThemePreference() {
        return this.themePreference;
    }

    getCurrentTheme() {
        return this.currentTheme;
    }
}

// Initialize theme manager globally
window.themeManager = new ThemeManager();
