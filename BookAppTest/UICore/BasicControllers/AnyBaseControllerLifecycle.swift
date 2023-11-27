//
//  AnyBaseControllerLifecycle.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation

public protocol AnyBaseControllerLifecycle {
    func viewWillAppearAgain()
    func viewDidAppearAtFirstTime()
    func viewDidAppearAgain()
    func configureUI()
    func configureActions()
}

public extension AnyBaseControllerLifecycle {
    func viewWillAppearAgain() { }
    func viewDidAppearAtFirstTime() { }
    func viewDidAppearAgain() { }
    func configureUI() { }
    func configureActions() { }
}
