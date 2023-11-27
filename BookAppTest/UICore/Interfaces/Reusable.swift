//
//  Reusable.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//
import UIKit

public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

// MARK: - Default implementation

public extension Reusable {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
