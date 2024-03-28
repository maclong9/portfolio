/**
 * @extends HTMLElement
 */
class PageSection extends HTMLElement {
  constructor() {
    super();
  }

  /**
   * @returns {void}
   */
  connectedCallback() {
    /** @type {string} */
    const title = this.getAttribute('title') || '';


    this.innerHTML = `
		<section id="${title.toLowerCase()}-section">
			<h2>${title}</h2>
			<slot></slot>
		</section>
    `;
  }
}

customElements.define('page-section', PageSection);
