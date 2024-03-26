let lastScrollTop = 0;

window.addEventListener("scroll", function () {
  let currentScroll = window.pageYOffset || document.documentElement.scrollTop;
  let header = document.querySelector("header");

  if (currentScroll > lastScrollTop && currentScroll > 200) {
    header.classList.add("hidden");
  } else {
    header.classList.remove("hidden");
  }

  lastScrollTop = currentScroll;
}, false);
