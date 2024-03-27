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

let currentPage = 1;
const postsPerPage = 10;

function handlePagination(data) {
  const totalPosts = data.posts.length;
  const totalPages = Math.ceil(totalPosts / postsPerPage);

  renderList(
    data.posts,
    "blog-list",
    (currentPage - 1) * postsPerPage,
    currentPage * postsPerPage,
  );

  // Check if there are less than 10 posts, hide pagination
  if (totalPosts <= postsPerPage) {
    return;
  }

  const paginationContainer = document.createElement("div");
  paginationContainer.classList.add("pagination");

  const prevButton = document.createElement("button");
  prevButton.textContent = "Previous";
  prevButton.addEventListener("click", () => {
    if (currentPage > 1) {
      currentPage--;
      renderList(
        data.posts,
        "blog-list",
        (currentPage - 1) * postsPerPage,
        currentPage * postsPerPage,
      );
      updatePaginationContainer();
    }
  });

  const nextButton = document.createElement("button");
  nextButton.textContent = "Next";
  nextButton.addEventListener("click", () => {
    if (currentPage < totalPages) {
      currentPage++;
      renderList(
        data.posts,
        "blog-list",
        (currentPage - 1) * postsPerPage,
        currentPage * postsPerPage,
      );
      updatePaginationContainer();
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
      renderList(
        data.posts,
        "blog-list",
        (currentPage - 1) * postsPerPage,
        currentPage * postsPerPage,
      );
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

  // Run updatePaginationContainer initially to hide the previous button if not applicable
  updatePaginationContainer();

  // Function to update the class of the current page button and manage button visibility
  function updatePaginationContainer() {
    const pageNumberButtons = pageNumberContainer.querySelectorAll("button");
    pageNumberButtons.forEach((button, index) => {
      if (index + 1 === currentPage) {
        button.classList.add("current-page");
      } else {
        button.classList.remove("current-page");
      }
    });

    // Show or hide previous and next buttons based on current page
    if (currentPage === 1) {
      prevButton.style.visibility = "hidden";
    } else {
      prevButton.style.visibility = "visible";
    }
    if (currentPage === totalPages) {
      nextButton.style.visibility = "hidden";
    } else {
      nextButton.style.visibility = "visible";
    }
  }
}

fetch("./static/data.json")
  .then((res) => res.json())
  .then((data) => {
    // Filter posts before today's date
    const currentDate = new Date();
    data.posts = data.posts.filter(({ date }) => new Date(date) < currentDate);
    handlePagination(data);
  });

