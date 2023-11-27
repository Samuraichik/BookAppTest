//
//  BaseTypeAlias.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation

public typealias EventHandler<T> = ((T) -> Void)
public typealias VoidClosure = () -> Void

public typealias ResultClosure<T> = (Result<T, Error>) -> Void
public typealias VoidResultClosure = (Result<Void, Error>) -> Void
