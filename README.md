# **RedApple**

**RedApple** is a Swift package designed to simplify the integration of web services in iOS applications. It streamlines the process of making HTTP requests, handling responses, and consuming RESTful APIs.

## **Installation**

You can integrate **RedApple** into your Xcode project using the [Swift Package Manager](https://swift.org/package-manager/).

### Steps:

1. Open your Xcode project.
2. Navigate to **File > Add Package Dependency**.
3. Enter the repository URL:  
   [https://github.com/dominique-pe/RedApple.git](https://github.com/dominique-pe/RedApple.git)
4. Choose the desired version and complete the integration.

## **Usage**

Once integrated, you can easily use **RedApple** to make HTTP requests. The following examples show how to initialize and use the package in your iOS app.

### **Example Usage**

#### 1. **Import RedApple**

To start using **RedApple**, import it into your Swift file:

```swift
import RedApple
```

#### 2. **RedApple Initialization and Basic Request**

You can create an instance of **RedApple** and use it to perform network requests.

```swift
lazy private var redApple = RedApple()
```

In the **viewDidLoad()** method or other lifecycle methods, you can initiate the request:

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    self.callService()
}
```

#### 3. **Making a Request**

Here is an example of how to make a POST request asynchronously with parameters:

```swift
private func callService() {
    Task {
        do {
            let urlString   = "https://ws.dominique.pe/v1/user/auth"
            let params      : [String : Any] = ["username": "someUser", "password": "myPassword123"]
            let response    = try await redApple.request(urlString, method: .post, parameters: params)
                
            DispatchQueue.main.async {
                self.handleSuccessResponse(response)
            }

        } catch let error as RedAppleError {
            DispatchQueue.main.async {
                self.handleError(error)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
```

This function performs an asynchronous network request and handles the response or error on the main thread.

#### 4. **Handling the Success Response**

You can decode the successful response and handle it as needed:

```swift
private func handleSuccessResponse(_ data: Data) {
    let user = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    print("User's full name: \(user?["firstname"] ?? "") \(user?["lastname"] ?? "")")
}
```

#### 5. **Handling Errors**

If an error occurs, you can parse the error response and display it to the user via an alert:

```swift
private func handleError(_ error: RedAppleError) {
    let errorJSON = try? JSONSerialization.jsonObject(with: error.data, options: []) as? [String: Any]
        
    let alertController = UIAlertController(title: "RedApple", 
                                            message: errorJSON?["message"] as? String ?? "An error occurred.", 
                                            preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
    self.present(alertController, animated: true, completion: nil)
}

```

### **Asynchronous Request Flow**

The `callService()` method asynchronously sends a network request to the specified URL.  
Upon receiving the response, it either:
- Handles success by decoding the data and updating the UI, or
- Catches any errors and displays an appropriate alert.

### **Additional Documentation**

For more details about API's and usage examples, refer to the official documentation at:  
[https://ws.dominique.pe#auth](https://ws.dominique.pe#auth)
