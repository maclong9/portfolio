/* @extends HTMLElement */
class PageFooter extends HTMLElement {
  constructor() {
    super();
  }

  /* @returns {void} */
  connectedCallback() {
    this.innerHTML = `
   	 <hr />
   	 <footer>
   	   <small><a href="#home">Mac Long</a>, 2024</small>
   	 </footer>
    `;
  }
}

customElements.define('page-footer', PageFooter);
