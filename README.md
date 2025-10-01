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
this updates the `static` branch with the new website content and a JavaScript file for the workers API, the `static` branch is watched by a [Cloudflare Worker]()
triggering an update of the live site.


## Tasks 

- [ ] Ensure post likes are setup and working.
- [ ] Slowly transition everything that is not written in a nice type safe addition of the WebUI DSL into new features of WebUI so that there aren't any awkward css or js files written in strings.
