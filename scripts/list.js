function renderList(items, list, start, end) {
  const itemList = document.getElementById(list);

  itemList.innerHTML = "";

  items.slice(start, end).forEach(({ title, date, path }) => {
    const listItem = document.createElement("a");

    listItem.classList.add("list-item");
    listItem.href = `./posts/${path}.html`;
    listItem.innerHTML = `
      <h2>${title}</h2>
      <span>
        ${new Date(date).toLocaleString("en-US", {
          month: "long",
          day: "numeric",
          year: "numeric",
        })}
      </span>
    `;
    itemList.appendChild(listItem);
  });
}

let currentPage = 1;
const postsPerPage = 10;

function handlePagination(data) {
  const totalPosts = data.posts.length;
  const totalPages = Math.ceil(totalPosts / postsPerPage);

  renderList(data.posts, "blog-list", (currentPage - 1) * postsPerPage, currentPage * postsPerPage);

  const paginationContainer = document.createElement("div");
  paginationContainer.classList.add("pagination");

  const prevButton = document.createElement("button");
  prevButton.textContent = "Previous";
  prevButton.addEventListener("click", () => {
    if (currentPage > 1) {
      currentPage--;
      renderList(data.posts, "blog-list", (currentPage - 1) * postsPerPage, currentPage * postsPerPage);
    }
  });

  const nextButton = document.createElement("button");
  nextButton.textContent = "Next";
  nextButton.addEventListener("click", () => {
    if (currentPage < totalPages) {
      currentPage++;
      renderList(data.posts, "blog-list", (currentPage - 1) * postsPerPage, currentPage * postsPerPage);
    }
  });

  paginationContainer.appendChild(prevButton);
  paginationContainer.appendChild(nextButton);

  document.getElementById("blog").appendChild(paginationContainer);
}

fetch("./static/data.json")
  .then((res) => res.json())
  .then((data) => {
    handlePagination(data);
  });

