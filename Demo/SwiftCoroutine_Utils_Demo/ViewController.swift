//
//  ViewController.swift
//  SwiftCoroutine_Utils_Demo
//
//  Created by Sergey Ladeiko on 12/9/20.
//

import UIKit
import SwiftCoroutine_Utils
import SwiftCoroutine

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    @IBAction func go(_ sender: UIButton) {
        sender.isEnabled = false
        startAnimation()
        queue.addCoOperation({
            DispatchQueue.global().coroutineFuture({
                try Coroutine.delay(.seconds(2))
            })
        }).whenComplete({
            self.stopAnimation()
            sender.isEnabled = true
        }, on: .main)
    }

    func startAnimation() {
        activityIndicator.startAnimating()
    }

    func stopAnimation() {
        activityIndicator.stopAnimating()
    }

}

