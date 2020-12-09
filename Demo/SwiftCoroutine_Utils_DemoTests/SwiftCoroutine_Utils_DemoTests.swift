//
//  SwiftCoroutine_Utils_DemoTests.swift
//  SwiftCoroutine_Utils_DemoTests
//
//  Created by Sergey Ladeiko on 12/9/20.
//

import XCTest
@testable import SwiftCoroutine_Utils_Demo
@testable import SwiftCoroutine_Utils
import SwiftCoroutine

class SwiftCoroutine_Utils_DemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOperations() throws {

        let expectation = XCTestExpectation()

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1

        var promises = [CoFuture<Void>]()
        var intervals = [(i: Int, start: Date, end: Date)]()

        for i in 0..<10 {
            promises.append(queue.addCoOperation({
                DispatchQueue.global().coroutineFuture({
                    let start = Date()
                    try Coroutine.delay(.milliseconds(200))
                    let end = Date()
                    intervals.append((i: i, start: start, end: end))
                })
            }))
        }

        var counter = promises.count
        promises.forEach({
            $0.whenComplete {
                counter -= 1
                if counter == 0 {
                    expectation.fulfill()
                }
            }
        })

        wait(for: [expectation], timeout: 60)

        intervals.forEach({ tested in
            XCTAssertFalse(intervals.contains(where: {
                (tested.i != $0.i) &&
                ((tested.start >= $0.start && tested.start < $0.end)
                || (tested.end >= $0.start && tested.end < $0.end)
                    || (tested.start < $0.start && tested.end > $0.end))
            }))
        })
    }

    func testFuture() {

        let expectation = XCTestExpectation()

        DispatchQueue.global().coroutineFuture({
            try Coroutine.delay(.milliseconds(100))
        }).whenComplete({
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }, on: .main)

        wait(for: [expectation], timeout: 10)
    }

}
