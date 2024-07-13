// Navigation Toggle
const nav = document.querySelector('nav');
const menuButton = document.querySelector('#nav-button');

const toggleMenu = () => {
    [nav, menuButton].forEach(el => el.dataset.active = true);
    
    document.addEventListener('click', (event) => {
        if (!nav.contains(event.target) && !menuButton.contains(event.target)) {
            [nav, menuButton].forEach(el => el.dataset.active = false);
        }
    });
}

// Skills Switcher
const skills = document.querySelector('.skills');
const details = document.querySelector('.details');
const firstSkill = document.querySelector("li button");

skills.style.setProperty("--active", 0);
details.querySelector("h3").innerText = firstSkill.dataset.skill;
details.querySelector("p").innerText = firstSkill.dataset.description;

skills.querySelectorAll("li button").forEach((item, index) => {
    item.addEventListener("click", e => {
        document.documentElement.querySelectorAll("[data-active]").forEach(el => {
            el.removeAttribute("data-active")
        });
        
        skills.style.setProperty("--active", index);
        item.setAttribute("data-active", true);
        
        details.querySelector("h3").innerText = item.dataset.skill;
        details.querySelector("p").innerText = item.dataset.description;
    });
});
