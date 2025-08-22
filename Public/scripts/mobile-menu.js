// Mobile menu functionality - replaces Alpine.js mobile menu
class MobileMenu {
    constructor() {
        this.isOpen = false;
        this.init();
    }

    init() {
        // Listen for toggle events
        document.addEventListener('click', (e) => {
            if (e.target.closest('[data-mobile-menu-toggle]')) {
                e.preventDefault();
                this.toggle();
            }
            
            if (e.target.closest('[data-mobile-menu-close]')) {
                e.preventDefault();
                this.close();
            }

            // Close menu when clicking menu items
            if (e.target.closest('.mobile-menu a')) {
                this.close();
            }

            // Close menu when clicking outside
            if (this.isOpen && !e.target.closest('.mobile-menu') && !e.target.closest('[data-mobile-menu-toggle]')) {
                this.close();
            }
        });

        // Listen for escape key
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && this.isOpen) {
                this.close();
            }
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
        const menu = document.querySelector('.mobile-menu');
        if (menu) {
            menu.style.display = 'block';
            // Trigger reflow for animation
            menu.offsetHeight;
            menu.classList.add('mobile-menu--open');
        }
        document.body.style.overflow = 'hidden';
    }

    close() {
        this.isOpen = false;
        const menu = document.querySelector('.mobile-menu');
        if (menu) {
            menu.classList.remove('mobile-menu--open');
            setTimeout(() => {
                if (!this.isOpen) {
                    menu.style.display = 'none';
                }
            }, 300); // Match transition duration
        }
        document.body.style.overflow = '';
    }
}

// Initialize mobile menu globally
window.mobileMenu = new MobileMenu();