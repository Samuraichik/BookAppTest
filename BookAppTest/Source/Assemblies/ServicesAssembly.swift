//
//  ServicesAssembly.swift
//  BookAppTest
//
//  Created by Oleksiy Humenyuk on 21.11.2022.
//

import Swinject
import Foundation

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AnyFirebaseService.self) { resolver in
            FirebaseService(dependencies: (
                resolver.resolve()!
            ))
        }.inObjectScope(.container)
    }
}
