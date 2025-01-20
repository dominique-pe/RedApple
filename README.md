# RedApple

**RedApple** is a Swift package that simplifies the integration of web services in iOS applications. It allows for easy HTTP requests, response handling, and consuming RESTful APIs.

## Installation

Add **RedApple** to your project using the [Swift Package Manager](https://swift.org/package-manager/):

1. Open your project in Xcode.
2. Go to **File > Swift Packages > Add Package Dependency**.
3. Enter the repository URL: [https://github.com/dominique-pe/RedApple.git](https://github.com/dominique-pe/RedApple.git)

## Usage

To make web requests, import **RedApple** and use the provided methods.

### Example Usage

```swift
import RedApple

// Define the endpoint URL
let endpoint = "https://api.example.com/v1/data"

// Define the parameters for the request
let parameters: [String: Any] = ["key": "value"]

// Perform a GET request
APIService.shared.get(url: endpoint, parameters: parameters) { result in
    switch result {
    case .success(let response):
        // Handle the successful response
        print("Data: \(response)")
    case .failure(let error):
        // Handle the error
        print("Error: \(error.localizedDescription)")
    }
}
```
