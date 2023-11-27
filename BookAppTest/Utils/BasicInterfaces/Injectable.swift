//
//  Injectable.swift
//  Utils
//
//  Created by oleksiy humenyuk on 27.09.2022.
//

import Foundation

public protocol Injectable {
    associatedtype Dependencies
}

public protocol InjectableViaInit: Injectable {
    init(dependencies: Dependencies)
}

public protocol InjectableViaFunc: Injectable {
    func inject(dependencies: Dependencies)
}
