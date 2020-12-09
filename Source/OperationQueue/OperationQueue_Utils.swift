//
//  OperationQueue+Utils.swift
//  SwiftCoroutine_Utils/OperationQueue
//
//  Created by Sergey Ladeiko on 12/9/20.
//

import Foundation
import SwiftCoroutine

public class CoBaseOperation: Operation {

    public override var isAsynchronous: Bool { true }
    public override var isExecuting: Bool { state == .isExecuting }
    public override var isFinished: Bool {
        if isCancelled && state != .isExecuting { return true }
        return state == .isFinished
    }

    fileprivate func _start() -> Bool {
        guard !isCancelled else { return false }
        state = .isExecuting
        return true
    }

    // MARK: - Private

    fileprivate enum State: String {
        case isReady
        case isExecuting
        case isFinished
    }

    fileprivate var state: State = .isReady {
        willSet(newValue) {
            willChangeValue(forKey: state.rawValue)
            willChangeValue(forKey: newValue.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }
}

public class CoOptionalResultOperation<T>: CoBaseOperation {

    public init(task: @escaping (() -> CoFuture<T?>)) {
        self.task = task
    }

    public func wait() -> CoFuture<T?> {

        if self.state == .isFinished {
            if let error = error {
                return .init(result: .failure(error))
            }
            else {
                return .init(result: .success(result!))
            }
        }

        let promise = CoPromise<T?>()
        waitersLock.lock()
        waiters.append(promise)
        waitersLock.unlock()
        return promise
    }

    public override func start() {
        guard _start() else { return }

        let f = self.task()

        f.whenFailure({ (error) in
            self.error = error
            self.state = .isFinished
            self.waitersLock.lock()
            let waiters = self.waiters
            self.waiters.removeAll()
            self.waitersLock.unlock()
            waiters.forEach({
                $0.fail(self.error!)
            })
        })

        f.whenSuccess({ (result) in
            self.result = result
            self.state = .isFinished
            self.waitersLock.lock()
            let waiters = self.waiters
            self.waiters.removeAll()
            self.waitersLock.unlock()
            waiters.forEach({
                $0.success(self.result!)
            })
        })
    }

    // MARK: - Private

    private let task: () -> CoFuture<T?>
    private var error: Error?
    private var result: T?
    private var waitersLock = NSLock()
    private var waiters = [CoPromise<T?>]()
}

public class CoResultOperation<T>: CoBaseOperation {

    public init(task: @escaping (() -> CoFuture<T>)) {
        self.task = task
    }

    public func wait() -> CoFuture<T> {

        if self.state == .isFinished {
            if let error = error {
                return .init(result: .failure(error))
            }
            else {
                return .init(result: .success(result!))
            }
        }

        let promise = CoPromise<T>()
        waitersLock.lock()
        waiters.append(promise)
        waitersLock.unlock()
        return promise
    }

    public override func start() {
        guard _start() else { return }

        let f = self.task()

        f.whenFailure({ (error) in
            self.error = error
            self.state = .isFinished
            self.waitersLock.lock()
            let waiters = self.waiters
            self.waiters.removeAll()
            self.waitersLock.unlock()
            waiters.forEach({
                $0.fail(self.error!)
            })
        })

        f.whenSuccess({ (result) in
            self.result = result
            self.state = .isFinished
            self.waitersLock.lock()
            let waiters = self.waiters
            self.waiters.removeAll()
            self.waitersLock.unlock()
            waiters.forEach({
                $0.success(self.result!)
            })
        })
    }

    // MARK: - Private

    private let task: () -> CoFuture<T>
    private var error: Error?
    private var result: T?
    private var waitersLock = NSLock()
    private var waiters = [CoPromise<T>]()
}

public class CoOperation: CoBaseOperation {

    public init(task: @escaping (() -> CoFuture<Void>)) {
        self.task = task
    }

    public func wait() -> CoFuture<Void> {

        if self.state == .isFinished {
            if let error = error {
                return .init(result: .failure(error))
            }
            else {
                return .init(result: .success(()))
            }
        }

        let promise = CoPromise<Void>()
        waitersLock.lock()
        waiters.append(promise)
        waitersLock.unlock()
        return promise
    }

    public override func start() {
        guard _start() else { return }

        let f = self.task()

        f.whenFailure({ (error) in
            self.error = error
            self.state = .isFinished
            self.waitersLock.lock()
            let waiters = self.waiters
            self.waiters.removeAll()
            self.waitersLock.unlock()
            waiters.forEach({
                $0.fail(self.error!)
            })
        })

        f.whenSuccess({ (result) in
            self.state = .isFinished
            self.waitersLock.lock()
            let waiters = self.waiters
            self.waiters.removeAll()
            self.waitersLock.unlock()
            waiters.forEach({
                $0.success(())
            })
        })
    }

    // MARK: - Private

    private let task: () -> CoFuture<Void>
    private var error: Error?
    private var waitersLock = NSLock()
    private var waiters = [CoPromise<Void>]()
}

public extension OperationQueue {

    @discardableResult
    func addCoOperation(_ task: @escaping (() -> CoFuture<Void>)) -> CoFuture<Void> {
        let operation = CoOperation(task: task)
        addOperation(operation)
        return operation.wait()
    }

    @discardableResult
    func addCoResultOperation<T>(_ task: @escaping (() -> CoFuture<T>)) -> CoFuture<T> {
        let operation = CoResultOperation<T>(task: task)
        addOperation(operation)
        return operation.wait()
    }

    @discardableResult
    func addCoResultOperation<T>(_ task: @escaping (() -> CoFuture<T?>)) -> CoFuture<T?> {
        let operation = CoOptionalResultOperation<T>(task: task)
        addOperation(operation)
        return operation.wait()
    }

}
