//
//  OperationQueue+Utils.swift
//  SwiftCoroutine_Utils/OperationQueue
//
//  Created by Sergey Ladeiko on 12/9/20.
//

import Foundation
import SwiftCoroutine

public extension CoFuture {

    // MARK: - whenComplete

    /// Adds an observer callback that is called when the `CoFuture` has any result.
    /// - Parameter callback: The callback that is called when the `CoFuture` is fulfilled.
    @inlinable func whenComplete(_ callback: @escaping (Result<Value, Error>) -> Void, on queue: DispatchQueue) {
        whenComplete { result in
            queue.async {
                callback(result)
            }
        }
    }

    /// Adds an observer callback that is called when the `CoFuture` has a success result.
    /// - Parameter callback: The callback that is called with the successful result of the `CoFuture`.
    @inlinable func whenSuccess(_ callback: @escaping (Value) -> Void, on queue: DispatchQueue) {
        whenSuccess { result in
            queue.async {
                callback(result)
            }
        }
    }

    /// Adds an observer callback that is called when the `CoFuture` has a failure result.
    /// - Parameter callback: The callback that is called with the failed result of the `CoFuture`.
    @inlinable func whenFailure(_ callback: @escaping (Error) -> Void, on queue: DispatchQueue) {
        whenFailure { result in
            queue.async {
                callback(result)
            }
        }
    }

    /// Adds an observer callback that is called when the `CoFuture` is canceled.
    /// - Parameter callback: The callback that is called when the `CoFuture` is canceled.
    @inlinable func whenCanceled(_ callback: @escaping () -> Void, on queue: DispatchQueue) {
        whenCanceled {
            queue.async {
                callback()
            }
        }
    }

    /// Adds an observer callback that is called when the `CoFuture` has any result.
    /// - Parameter callback: The callback that is called when the `CoFuture` is fulfilled.
    @inlinable func whenComplete(_ callback: @escaping () -> Void, on queue: DispatchQueue) {
        whenComplete {
            queue.async {
                callback()
            }
        }
    }

}
