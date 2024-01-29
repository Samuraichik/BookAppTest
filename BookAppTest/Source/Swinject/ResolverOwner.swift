//
//  ResolverOwner.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 21.11.2022.
//

import Swinject

final class ResolverOwner: AnyScreenResolverOwner,
                           AnyCoordinatorResolverOwner,
                           AnySystemResolverOwner,
                           InjectableViaInit {
    
    typealias Dependencies = Resolver
    
    let resolver: Resolver
    
    init(dependencies: Dependencies) {
        resolver = dependencies
    }
}
