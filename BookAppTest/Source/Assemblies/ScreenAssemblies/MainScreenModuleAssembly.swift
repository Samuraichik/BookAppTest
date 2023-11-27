//
//  MainScreenModuleAssembly.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 21.11.2023.
//

import Swinject

final class MainScreenModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MainScreenViewModel.self) { (resolver, flow: AnyMainScreenCoordinator) in
            MainScreenViewModel(dependencies: (
                flow,
                resolver.resolve()!
            ))
        }
        
        container.register(MainScreenViewController.self) { (resolver, flow: AnyMainScreenCoordinator) in
            let controller = MainScreenViewController()

            controller.inject(dependencies: (
                resolver.resolve(flow)!
            ))
                              
            return controller
        }
    }
}
