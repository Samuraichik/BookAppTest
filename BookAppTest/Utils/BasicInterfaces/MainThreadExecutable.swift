//
//  MainThreadExecutable.swift
//  Utils
//
//  Created by oleksiy humenyuk on 27.09.2022.
//

import Foundation

@propertyWrapper
public struct MainThreadExecutable<T> {
    private var action: ((T) -> Void)?

    public var wrappedValue: (_ data: T) -> Void {
        get {
            return { data in
                DispatchQueue.main.async {
                    action?(data)
                }
            }
        }

        set {
            action = newValue
        }
    }

    public init(_ action: @escaping (T) -> Void) {
        wrappedValue = action
    }
}

@propertyWrapper
public struct MainVoidThreadExecutable {
    private var action: (() -> Void)?

    public var wrappedValue: () -> Void {
        get {
            return {
                DispatchQueue.main.async {
                    action?()
                }
            }
        }

        set {
            action = newValue
        }
    }

    public init(_ action: @escaping () -> Void) {
        wrappedValue = action
    }
}

