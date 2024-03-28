class PageHead extends HTMLElement {
	constructor() {
		super();
	}

	connectedCallback() {
		/** @type {{ title: string, description: string, path: string, type: string, image: string }} */
		const { title, description, path, type, image } = this.attributes;
		const url = `https://maclong9.github.io/portfolio/${path}`;
		
		this.innerHTML = `
	    <meta charset="utf-8" />
	    <meta name="viewport" content="width=device-width" />
	
	    <link rel="icon" href="./static/favicon.ico" />
	    <link rel="shortcut icon" href="./static/favicon.ico" />
	    <link rel="stylesheet" href="./static/style.css" />
	    <title>${title}</title>
	    <meta name="description" content="${description}" />
	
	    <meta property="og:url" content="${url}" />
	    <meta property="og:type" content="${type}" />
	    <meta property="og:title" content="${title}" />
	    <meta property="og:description" content="${description}" />
	    <meta property="og:image" content="${image}" />
	
	    <meta name="twitter:card" content="summary_large_image" />
	    <meta property="twitter:domain" content="https://maclong9.github.io" />
	    <meta property="twitter:url" content="${url}" />
	    <meta name="twitter:title" content="${title}" />
	    <meta name="twitter:description" content="${description}" />
	    <meta name="twitter:image" content="${image}" />
		`;
	}
}

customElements.define('page-head', PageHead, { extends: 'head' });
