# RedApple

**RedApple** is a Swift package that simplifies the integration of web services in iOS applications. It allows for easy HTTP requests, response handling, and consuming RESTful APIs.

## Installation

Add **RedApple** to your project using the [Swift Package Manager](https://swift.org/package-manager/):

1. Open your project in Xcode.
2. Go to **File > Add Package Dependency**.
3. Enter the repository URL: [https://github.com/dominique-pe/RedApple.git](https://github.com/dominique-pe/RedApple.git)

## Usage

To make web requests, import **RedApple** and use the provided methods.

### Example Usage


```swift
import RedApple
```

RedApple Initialization and calls the callService() function when the view is loaded to initiate the network request.
```swift
lazy private var redApple = RedApple()

override func viewDidLoad() {
    super.viewDidLoad()
    self.callService()
}
```

Asynchronously makes a network request using RedApple and handles the response or error on the main thread.
```swift
private func callService() {
    Task {
        do {
            
            let urlString   = "https://ws.dominique.pe/v1/user/auth"
            let params      : [String : Any] = ["username": "someUser", "password": "myPassword123"]
            let response    = try await redApple.request(urlString, method: .post, parameters: params)
                
            DispatchQueue.main.async { self.handleSuccessResponse(response) }

        } catch let error as RedAppleError {
                
            DispatchQueue.main.async { self.handleError(error) }
                
        } catch { print(error.localizedDescription) }
    }
}

private func handleSuccessResponse(_ data: Data) {
    let user = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    print("User's fullname: \(user?["firstname"] ?? "") \(user?["lastname"] ?? "")")
}
    
private func handleError(_ error: RedAppleError) {
    let errorJSON = try? JSONSerialization.jsonObject(with: error.data, options: []) as? [String: Any]
        
    let alertController = UIAlertController(title: "RedApple", message: errorJSON?["message"] as? String ?? "", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
    self.present(alertController, animated: true, completion: nil)
}
```
