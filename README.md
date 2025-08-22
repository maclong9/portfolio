# Portfolio

[Live Site](https://maclong.uk)

Personal portfolio static site built with [Swift](https://swift.org) and [WebUI](https://github.com/maclong9/web-ui). 

## Requirements

Requires Swift `6.1` or later.

## Usage

Run the following to generate an `.output` directory containing the website.

```
swift run
```

## Deployment

This application is built with the [Build Static Site](https://github.com/maclong9/portfolio/blob/main/.github/workflows/build.yml) action,
this updates the `static` branch with the new website content, the `static` branch is watched by [Cloudflare Pages](https://pages.cloudflare.com)
triggering an update of the live site.


## Tasks 

- [ ] Clear out all duplicate tailwind classes e.g. if the text and background colour are set in @Sources/Application/Components/Layout.swift we don't need to set those colours elsewhere unless the colour differs.
- [ ] Move all scripts as colocated to their various components (e.g. the card animations inside a Script() WebUI element and just have it handle each individual card entering the view for simplicity, and the particle network logic should be within the ParticleNetwork component)
