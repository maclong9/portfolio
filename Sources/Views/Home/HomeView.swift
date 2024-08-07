import Vapor
import SwiftHtml
import SwiftCss

struct HomeView: TagRepresentable {
  let props: HomeProps
  
  init(_ props: HomeProps) {
    self.props = props
    stylesheetGenerator.addModules([HomeStyles])
  }
  
  func build() -> Tag {
    return Main {
      Section {
        H1("Mac Long")
        H2("About")
        P("""
          I'm a driven software engineer passionate about crafting highly efficient
          applications and seeking new ways to optimize their performance. I do this using industry-standard tools and am constantly learning and perfecting my craft.
          """)
      }.id("about")
      
      Section {
        H2("Skills")
        Ul {
          Span().class("highlight")
          for skill in props.skills {
            Li {
              Button {
                Span(skill.name).class("visually-hidden")
              }.class("skill-button")
                .setContents(skill.icon)
                .data(key: "skill", skill.name)
                .data(key: "description", skill.description)
            }
          }
        }.class("skills")
        Div {
          H3(props.skills[0].name)
          P(props.skills[0].description)
        }.class("details")
      }.id("skills")
      
      Section {
        Div {
          H2("Projects")
        }.id("section-header")
        Div {
          for project in props.projects {
            if !project.hidden {
              Div {
                Div {
                  Span(project.new ? "New" : "").class("new")
                  H3(project.name)
                  Span(project.summary)
                }.class("details")
                Img(src: "projects/\(project.name.lowercased()).webp", alt: "\(project.name) cover image")
                Div {
                  Span(project.tag)
                  A("View").href(project.url)
                }.class("metadata")
              }.class("card")
            }
          }
        }.class("projects")
      }.id("projects")
      Script {
        Text("""
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
        """)
      }
    }
  }
}
