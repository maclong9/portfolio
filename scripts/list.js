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

  const pageNumberContainer = document.createElement("div");
  pageNumberContainer.classList.add("page-numbers");

  // Page numbers
  for (let i = 1; i <= totalPages; i++) {
    const pageNumberButton = document.createElement("button");
    pageNumberButton.textContent = i;
    pageNumberButton.addEventListener("click", () => {
      currentPage = i;
      renderList(data.posts, "blog-list", (currentPage - 1) * postsPerPage, currentPage * postsPerPage);
      updatePaginationContainer();
    });
		if (i === currentPage) {
			pageNumberButton.classList.add("current-page");
		}
    pageNumberContainer.appendChild(pageNumberButton);
  }


  paginationContainer.appendChild(prevButton);
  paginationContainer.appendChild(pageNumberContainer);
  paginationContainer.appendChild(nextButton);

  document.getElementById("blog").appendChild(paginationContainer);
}

fetch("./static/data.json")
  .then((res) => res.json())
  .then((data) => {
    handlePagination(data);
  });

