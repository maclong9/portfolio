fetch("./static/data.json")
  .then((res) => res.json())
  .then((data) => {
    const sortedPosts = data.posts.sort((a, b) =>
      new Date(b.date) - new Date(a.date)
    );
    renderList(sortedPosts, "blog-list");
  });

function renderList(items, list) {
  const itemList = document.getElementById(list);

  itemList.innerHTML = "";

  items.forEach(({ title, date, path }) => {
    const listItem = document.createElement("a");

    listItem.classList.add("list-item");
    listItem.href = `./posts/${path}`;
    listItem.innerHTML = `
      <h2>${title}</h2>
      <span>
        ${
      new Date(date).toLocaleString("en-US", {
        month: "long",
        day: "numeric",
        year: "numeric",
      })
    }
      </span>
    `;
    itemList.appendChild(listItem);
  });
}
