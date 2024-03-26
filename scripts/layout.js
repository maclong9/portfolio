class LayoutHeader extends HTMLElement {
  connectedCallback() {
    this.innerHTML = `
      <header class="index">
        <nav>
          <div id="links">
            <a href="#home">Home</a>
            <a href="#about">About</a>
            <a href="#blog">Blog</a>
          </div>
          <div id="icons">
            <a href="https://sciences.social/@mac" target="_blank">
              <!-- Mastodon SVG -->
            </a>
            <a href="https://github.com/maclong9" target="_blank">
              <!-- GitHub SVG -->
            </a>
          </div>
        </nav>
      </header>
    `;
  }
}

class LayoutFooter extends HTMLElement {
  connectedCallback() {
    this.innerHTML = `
      <footer>
        <small><a href="#home">Mac Long</a>, 2024</small>
      </footer>
    `;
  }
}

customElements.define('layout-header', LayoutHeader);
customElements.define('layout-footer', LayoutFooter);
