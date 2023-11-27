//
//  ResolverExtensions.swift
//  BookAppTest
//
//  Created by Oleksiy Humenyuk on 21.11.2022.
//

import Swinject

extension Resolver {
    func resolve<T>() -> T { resolve(T.self)! }
    func resolve<T, A>(_ argument: A) -> T { resolve(T.self, argument: argument)! }
    func resolve<T, A, B>(_ argument: A, _ arg: B) -> T { resolve(T.self, arguments: argument, arg)! }
    func resolve<T, A, B, C>(_ argument: A, _ arg2: B, _ arg3: C) -> T { resolve(T.self, arguments: argument, arg2, arg3)! }
    func resolve<T, A, B, C, D>(_ argument: A, _ arg2: B, _ arg3: C, _ arg4: D) -> T { resolve(T.self, arguments: argument, arg2, arg3, arg4)! }
    func resolve<T, A, B, C, D, E>(_ argument: A, _ arg2: B, _ arg3: C, _ arg4: D, _ arg5: E) -> T { resolve(T.self, arguments: argument, arg2, arg3, arg4, arg5)! }
    private var resolverOwner: ResolverOwner { resolve() }

    var screenResolverOwner: AnyScreenResolverOwner { resolverOwner }
    var coordinatorResolverOwner: AnyCoordinatorResolverOwner { resolverOwner }
    var servicesResolverOwner: AnyServiceResolverOwner { resolverOwner }
    var systemResolverOwner: AnySystemResolverOwner { resolverOwner }
    
}
