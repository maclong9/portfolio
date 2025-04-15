// snippet.DECLARATION
func sayHello(name: String? = nil) {
  print("Hello, \(name ?? "World")!")
}

// snippet.USAGE
let message = sayHello(name: "Alice")
print(message)
