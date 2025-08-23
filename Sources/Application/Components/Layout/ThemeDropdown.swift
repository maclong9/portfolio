import WebUI

struct ThemeDropdown: Element {
  public var body: some Markup {
    Stack(classes: ["relative", "theme-dropdown"]) {
      // Theme toggle button
      Button(
        classes: [
          "p-2", "text-zinc-500", "hover:text-zinc-700",
          "dark:text-zinc-400", "dark:hover:text-zinc-200",
          "rounded-lg", "hover:bg-zinc-100", "dark:hover:bg-zinc-700",
          "transition-colors", "cursor-pointer",
        ],
        label: "Change theme",
        data: ["theme-toggle": "true"]
      ) {
        Icon(
          name: "sun",
          classes: ["hidden"],
          data: ["theme-icon": "light"]
        )
        Icon(
          name: "moon",
          classes: ["hidden"],
          data: ["theme-icon": "dark"]
        )
        Icon(
          name: "palette",
          data: ["theme-icon": "system"]
        )
      }

      // Dropdown menu
      Stack(
        classes: [
          "absolute", "right-0", "top-full", "mt-2", "w-48", "bg-white", "dark:bg-zinc-800",
          "rounded-lg", "shadow-lg", "border", "border-zinc-200", "dark:border-zinc-700",
          "py-1", "z-50", "theme-dropdown-menu", "hidden",
        ],
      ) {

        // System theme option
        Button(
          classes: [
            "w-full", "px-4", "py-2", "text-left", "text-sm", "flex", "items-center", "space-x-3",
            "text-zinc-700", "dark:text-zinc-300", "hover:bg-zinc-50", "dark:hover:bg-zinc-700",
            "transition-colors", "cursor-pointer", "theme-option",
          ],
          data: ["theme-option": "system"]
        ) {
          Icon(name: "palette")
          Text("System")
        }

        // Light theme option
        Button(
          classes: [
            "w-full", "px-4", "py-2", "text-left", "text-sm", "flex", "items-center", "space-x-3",
            "text-zinc-700", "dark:text-zinc-300", "hover:bg-zinc-50", "dark:hover:bg-zinc-700",
            "transition-colors", "cursor-pointer", "theme-option",
          ],
          data: ["theme-option": "light"]
        ) {
          Icon(name: "sun")
          Text("Light")
        }

        // Dark theme option
        Button(
          classes: [
            "w-full", "px-4", "py-2", "text-left", "text-sm", "flex", "items-center", "space-x-3",
            "text-zinc-700", "dark:text-zinc-300", "hover:bg-zinc-50", "dark:hover:bg-zinc-700",
            "transition-colors", "cursor-pointer", "theme-option",
          ],
          data: ["theme-option": "dark"]
        ) {
          Icon(name: "moon")
          Text("Dark")
        }
      }

      // Component-colocated styles and script
      Style(content: {
        """
        .theme-dropdown-menu {
            display: none;
            opacity: 0;
            transform: translateY(-10px) scale(0.95);
            transition: opacity 0.15s ease-in, transform 0.15s ease-in;
        }

        .theme-dropdown-menu--open {
            display: block;
            opacity: 1;
            transform: translateY(0) scale(1);
            transition: opacity 0.2s ease-out, transform 0.2s ease-out;
        }

        .theme-option--active {
            background-color: rgb(240 253 250);
            color: rgb(15 118 110);
        }

        .dark .theme-option--active {
            background-color: rgb(19 78 74 / 0.5);
            color: rgb(94 234 212);
        }

        [data-theme-icon] {
            display: none;
        }

        [data-theme-icon="system"] {
            display: block;
        }
        """
      })

      Script(
        placement: .body,
        content: {
          """
          // Theme dropdown functionality - colocated with ThemeDropdown component
          (function() {
              let isDropdownOpen = false;

              function initThemeDropdown() {
                  // Listen for dropdown toggle
                  document.addEventListener('click', (e) => {
                      const themeToggle = e.target.closest('[data-theme-toggle]');
                      if (themeToggle) {
                          e.preventDefault();
                          toggleDropdown();
                          return;
                      }

                      const themeOption = e.target.closest('[data-theme-option]');
                      if (themeOption) {
                          e.preventDefault();
                          const theme = themeOption.dataset.themeOption;
                          setTheme(theme);
                          updateDropdownUI();
                          closeDropdown();
                          return;
                      }

                      // Close dropdown when clicking outside
                      if (isDropdownOpen && !e.target.closest('.theme-dropdown')) {
                          closeDropdown();
                      }
                  });

                  // Update UI initially and when theme changes
                  updateDropdownUI();
                  
                  // Listen for theme changes
                  const observer = new MutationObserver(() => {
                      updateDropdownUI();
                  });
                  
                  observer.observe(document.documentElement, {
                      attributes: true,
                      attributeFilter: ['data-theme']
                  });
              }

              function toggleDropdown() {
                  if (isDropdownOpen) {
                      closeDropdown();
                  } else {
                      openDropdown();
                  }
              }

              function openDropdown() {
                  isDropdownOpen = true;
                  const dropdown = document.querySelector('.theme-dropdown-menu');
                  if (dropdown) {
                      dropdown.classList.remove('hidden');
                      // Trigger reflow for animation
                      dropdown.offsetHeight;
                      dropdown.classList.add('theme-dropdown-menu--open');
                  }
              }

              function closeDropdown() {
                  isDropdownOpen = false;
                  const dropdown = document.querySelector('.theme-dropdown-menu');
                  if (dropdown) {
                      dropdown.classList.remove('theme-dropdown-menu--open');
                      setTimeout(() => {
                          if (!isDropdownOpen) {
                              dropdown.classList.add('hidden');
                          }
                      }, 200); // Match transition duration
                  }
              }

              function setTheme(theme) {
                  localStorage.setItem('theme', theme);
                  updateTheme();
              }

              function updateTheme() {
                  const themePreference = localStorage.getItem('theme') || 'system';
                  let actualTheme = 'light';

                  if (themePreference === 'dark') {
                      actualTheme = 'dark';
                  } else if (themePreference === 'system') {
                      actualTheme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
                  }

                  document.documentElement.setAttribute('data-theme', actualTheme);
              }

              function updateDropdownUI() {
                  const savedTheme = localStorage.getItem('theme') || 'system';
                  
                  // Update theme toggle button icon
                  const toggleIcons = document.querySelectorAll('[data-theme-icon]');
                  toggleIcons.forEach(icon => {
                      icon.style.display = 'none';
                  });
                  
                  const activeIcon = document.querySelector(`[data-theme-icon="${savedTheme}"]`);
                  if (activeIcon) {
                      activeIcon.style.display = 'block';
                  }

                  // Update dropdown options
                  const options = document.querySelectorAll('[data-theme-option]');
                  options.forEach(option => {
                      const isActive = option.dataset.themeOption === savedTheme;
                      option.classList.toggle('theme-option--active', isActive);
                  });
              }

              // Initialize when DOM is ready
              if (document.readyState === 'loading') {
                  document.addEventListener('DOMContentLoaded', initThemeDropdown);
              } else {
                  initThemeDropdown();
              }
          })();
          """
        }
      )
    }
  }
}
