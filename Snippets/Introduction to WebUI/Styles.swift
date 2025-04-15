// snippet.hide
import WebUI

// snippet.show
let styledContent = Stack {
  Heading(level: .one) { "Hello, world!" }
    .font(size: .xl, weight: .bold, decoration: .underline)
}
.background(color: .neutral(._100))
.background(color: .neutral(._950), on: .dark)
