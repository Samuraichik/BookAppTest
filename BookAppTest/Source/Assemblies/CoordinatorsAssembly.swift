//
//  CoordinatorsAssembly.swift
//  BookAppTest
//
//  Created by Oleksiy Humenyuk on 21.11.2022.
//

import Swinject

final class CoordinatorsAssembly: Assembly {
    func assemble(container: Container) {        
        container.register(AnyMainCoordinator.self) { (resolver) in
            let resolverOwner = resolver.resolve(ResolverOwner.self)!
            
            return MainFlowCoordinator(dependencies: (
                resolverOwner,
                resolverOwner,
                resolverOwner
            ))
        }
    }
}
