class LayoutHeader extends HTMLElement {
  connectedCallback() {
    this.innerHTML = `

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
