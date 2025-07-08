// Notes.swift
// Projects.swift
import Foundation
import Shared
// Missing.swift
import WebUI

struct Missing: Document {
    var metadata: Metadata {
        Metadata(from: Application().metadata)
    }

    var path: String? {
        "404"
    }

    var pageTitle: String {
        "404 - Page Not Found"
    }

    var body: some Markup {
        Layout(
            title: "404 - Page Not Found",
            description: "Whoops, unfortunately that page either no longer or never existed in the first place."
        ) {
            Link(to: "/") { "Head back home?" }.styled().padding(at: .vertical)
        }
    }
}
