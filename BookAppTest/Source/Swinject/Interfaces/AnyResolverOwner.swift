//
//  AnyResolverOwner.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 27.09.2022.
//

import Swinject

// MARK: - AnyResolverOwner

protocol AnyResolverOwner {
    var resolver: Resolver { get }
}
