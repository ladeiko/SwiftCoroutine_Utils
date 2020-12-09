# SwiftCoroutine_Utils

Some useful extensions for SwiftCoroutine library [https://github.com/belozierov/SwiftCoroutine](https://github.com/belozierov/SwiftCoroutine)

## Installation

### Cocoapods

```ruby
pod 'SwiftCoroutine_Utils'
```

or:

```ruby
pod 'SwiftCoroutine_Utils/OperationQueue'
pod 'SwiftCoroutine_Utils/CoFuture'
```

## Concept

Add some methods for CoFuture and OperationQueue like:

```swift

public extension CoFuture {

    func whenComplete(_ callback: @escaping (Result<Value, Error>) -> Void, on queue: DispatchQueue)
    func whenSuccess(_ callback: @escaping (Value) -> Void, on queue: DispatchQueue)
    func whenFailure(_ callback: @escaping (Error) -> Void, on queue: DispatchQueue)
    func whenCanceled(_ callback: @escaping () -> Void, on queue: DispatchQueue)
    func whenComplete(_ callback: @escaping () -> Void, on queue: DispatchQueue)

}

public extension OperationQueue {

    func addCoOperation(_ task: @escaping (() -> CoFuture<Void>)) -> CoFuture<Void>
    func addCoResultOperation<T>(_ task: @escaping (() -> CoFuture<T>)) -> CoFuture<T>
    func addCoResultOperation<T>(_ task: @escaping (() -> CoFuture<T?>)) -> CoFuture<T?>

}
```

## Usage

See [Demo/SwiftCoroutine\_Utils\_Demo/ViewController.swift](Demo/SwiftCoroutine_Utils_Demo/ViewController.swift)

## Author

* Siarhei Ladzeika <sergey.ladeiko@gmail.com>

## LICENSE

See [LICENSE](LICENSE)
