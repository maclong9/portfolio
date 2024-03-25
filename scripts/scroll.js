let lastScrollTop = 0;

window.addEventListener("scroll", function () {
  let currentScroll = window.pageYOffset || document.documentElement.scrollTop;
  let header = document.querySelector("header");
  let span = document.querySelector("#tagline");
  console.log(currentScroll);

  if (currentScroll > lastScrollTop && currentScroll > 500) {
    header.classList.add("hidden");
  } else {
    header.classList.remove("hidden");
  }

  if (currentScroll > 470) {
    header.classList.add("scrolled");
    span.classList.add("scrolled");
  } else {
    header.classList.remove("scrolled");
    span.classList.remove("scrolled");
  }

  lastScrollTop = currentScroll;
}, false);
