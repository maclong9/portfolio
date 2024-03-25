fetch("./static/data.json")
  .then((res) => res.json())
  .then((data) => {
    renderList(data.projects, "project-list");
    renderList(data.posts, "blog-list");
  });

function renderList(items, list) {
  const itemList = document.getElementById(list);

  itemList.innerHTML = "";

  items.forEach(({ title, date, image, path, link }) => {
    const listItem = document.createElement("div");
    const isPost = date !== undefined;

    listItem.innerHTML = `
            <a 
              class="list-item" 
              href="${isPost ? `./posts/${path}` : link}"
              target="${!isPost ? "_blank" : ""}"
            >
              ${
                image !== undefined
                  ? `<img src="${image}" alt="${title} Image" width="266.67" height="150" />`
                  : ""
              }
              <h2>${title}</h2>
              ${
                date !== undefined
                  ? `
                <span>
                  ${new Date(date).toLocaleString("en-US", {
                    month: "long",
                    day: "numeric",
                    year: "numeric",
                  })}
                </span>
              `
                  : ""
              }
            </a>
          `;
    itemList.appendChild(listItem);
  });
}
