//
//  Pagination.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 20.11.2023.
//

import Foundation

struct Pagination: AnyModel {

    // MARK: - Properties

    public private(set) var offset: Int
    public private(set) var count: Int

    public init(offset: Int = .zero, count: Int = .zero) {
        self.offset = offset
        self.count = count
    }

    public mutating func update(offset: Int, count: Int) {
        self.offset = offset
        self.count = count
    }
}

extension Pagination {
    var hasMore: Bool {
        offset < count
    }
}
