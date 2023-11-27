//
//  SplashScreenModuleAssembly.swift
//  Rococo
//
//  Created by oleksiy humenyuk on 18.08.2023.
//

import Swinject

final class SplashScreenModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SplashScreenViewModel.self) { (resolver, flow: AnySplashScreenCoordinator) in
            SplashScreenViewModel(dependencies: (
                flow,
                resolver.resolve()!
            ))
        }
        
        container.register(SplashScreenViewController.self) { (resolver, flow: AnySplashScreenCoordinator) in
            let controller = SplashScreenViewController()

            controller.inject(dependencies: (
                resolver.resolve(flow)!
            ))
                              
            return controller
        }
    }
}
