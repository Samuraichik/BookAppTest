//
//  MainThreadExecutable.swift
//  Utils
//
//  Created by oleksiy humenyuk on 27.09.2022.
//

import Foundation

@MainActor
class MainThreadActor<T> {
    static func execute(_ action: @escaping (T) -> Void, with data: T) {
        action(data)
    }
}

@propertyWrapper
public struct MainTaskThreadExecutable<T> {
    private var action: ((T) -> Void)?

    public var wrappedValue: (_ data: T) -> Void {
        get {
            return { data in
                if Thread.isMainThread {
                    self.action?(data)
                } else {
                    Task {
                        await MainThreadActor.execute(self.action!, with: data)
                    }
                }
            }
        }

        set {
            action = newValue
        }
    }

    public init(_ action: @escaping (T) -> Void) {
        self.wrappedValue = action
    }
}


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

