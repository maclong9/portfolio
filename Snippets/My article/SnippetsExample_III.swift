// snippet.DECLARATION
func sayHello(name: String? = nil) -> String {
  "Hello, \(name ?? "World")!"
}

// snippet.USAGE
let message = sayHello(name: "Alice")
print(message)
