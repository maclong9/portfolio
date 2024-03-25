async function fetchData() {
  try {
    return await fetch("index.json").then((res) => res.json());
  } catch (error) {
    console.error("Error fetching data:", error);
    return [];
  }
}

class ListItem extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: "opne" });
  }

  connectedCallback() {
    this.render();
  }

  render() {
    const item = this.getAttrivute("data-item");
    this.shadowRoot.innerHTML = `
      <div class="list-item">${post}</div>
    `;
  }
}

customElements.define("list-item", ListItem);

async function renderItems() {
  const projectList = document.getElementById("project-list");
  const blogList = document.getElementById("blog-list");
  const data = await fetchData();

  data.projects.forEach((project) => {
    const listItem = document.createElement("list-item");
    listItem.setAttribute("data-project", project);
    projectList.appendChild(listItem);
  });
}

renderItems();
