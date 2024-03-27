async function fetchDataAndRender() {
  try {
    const response = await fetch("./static/data.json");
    const data = await response.json();
    const currentDate = new Date();
    const sortedPosts = data.posts
      .filter((post) => new Date(post.date) <= currentDate)
      .sort((a, b) => new Date(b.date) - new Date(a.date));
    renderList(data.posts, "blog-list");
  } catch (error) {
    console.error("Error fetching or parsing data:", error);
  }
}

function renderList(items, list, start, end) {
  const itemList = document.getElementById(list);

  itemList.innerHTML = "";

  items.forEach(({ title, date, path }) => {
    const listItem = document.createElement("a");

    listItem.classList.add("list-item");
    listItem.href = `./posts/${path}.html`;
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

fetchDataAndRender();
