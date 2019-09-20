//
//  DynamicValue.swift
//  HelloMVVM
//
//  Created by User on 19/9/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

class DynamicValue<T> {
    typealias CompletionHandler = ((T) -> Void)

    var value: T {
        didSet {
            notify()
        }
    }

    private var observers = [String: CompletionHandler]()

    init(_ value: T) {
        self.value = value
    }

    public func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }

    public func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        addObserver(observer, completionHandler: completionHandler)
        notify()
    }

    private func notify() {
        observers.forEach { $0.value(value) }
    }

    deinit {
        observers.removeAll()
    }
}
