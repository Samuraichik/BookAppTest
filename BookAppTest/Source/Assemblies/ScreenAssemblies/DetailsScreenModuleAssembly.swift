//
//  DetailsScreenModuleAssembly.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 23.11.2023.
//

import Swinject

final class DetailsScreenModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DetailsScreenViewModel.self) { (
            resolver,
            flow: AnyDetailsScreenCoordinator,
            rootModel:RootModel,
            bookId: Int
        ) in
            DetailsScreenViewModel(dependencies: (
                flow,
                rootModel,
                bookId
            ))
        }
        
        container.register(DetailsScreenViewController.self) { (
            resolver,
            flow: AnyDetailsScreenCoordinator,
            rootModel: RootModel,
            bookId: Int
        ) in
            let controller = DetailsScreenViewController()
            
            controller.inject(dependencies: (
                resolver.resolve(
                    flow,
                    rootModel,
                    bookId
                )!
            ))
            
            return controller
        }
    }
}
