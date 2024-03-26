export class MetaData extends HTMLElement {
  connectedCallback() {
    const title = this.getAttribute('title');
    const description = this.getAttribute('description');
    const image = this.getAttribute('image');
    const type = this.getAttribute('type');
    const url = this.getAttribute('url');

    this.createMetaTag('og:title', title);
    this.createMetaTag('og:description', description);
    this.createMetaTag('og:image', image);
    this.createMetaTag('og:type', type);
    this.createMetaTag('og:url', url);

    this.createMetaTag('twitter:title', title);
    this.createMetaTag('twitter:description', description);
    this.createMetaTag('twitter:image', image);
    this.createMetaTag('twitter:card', type);
    this.createMetaTag('twitter:url', url);
  }

  createMetaTag(name, content) {
    const metaTag = document.createElement('meta');
    metaTag.setAttribute('property', name);
    metaTag.setAttribute('content', content);
    document.head.appendChild(metaTag);
  }
}
