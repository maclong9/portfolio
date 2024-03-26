export class CustomMeta extends HTMLElement {
  connectedCallback() {
    const { title, description, image, type, url } = this.getAttributes();

    this.createMetaTag('charset', 'UTF-8');
    this.createMetaTag('name', 'viewport', 'content', 'width=device-width, initial-scale=1.0');
    this.createMetaTag('title', title);

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

  createMetaTag(tagName, attribute, content) {
    const metaTag = document.createElement('meta');
    if (content) {
      metaTag.setAttribute(attribute, content);
    } else {
      metaTag.setAttribute('charset', 'UTF-8');
      metaTag.setAttribute('name', tagName);
    }
    document.head.appendChild(metaTag);
  }
}
