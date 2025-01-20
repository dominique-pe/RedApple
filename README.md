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
```

```swift
private func callService() async {

    // Define the endpoint URL and define the parameters for the request
    let urlString  = "https://ws.dominique.pe/v1/list/books"
    let parameters : [String: Any] = ["user": "example", "password": "password1234"]
        
    do {
        let responseData = try await self.redApple.request(urlString, withMethod: .get)
        print("Another \(responseData)")

    } catch let error as RedAppleError {
            self.showAlert(error.message)
    } catch { print("Unexpected error: \(error.localizedDescription)") }
}
```
