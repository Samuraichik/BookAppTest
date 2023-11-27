//
//  SceneDelegate.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 20.11.2023.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties
    
    let utilsAssemblies: [Assembly] = [
        ServicesAssembly(),
        CoordinatorsAssembly(),
        SystemAssembly()
    ]
    
    let mainFlowAssemblies: [Assembly] = [
        SplashScreenModuleAssembly(),
        MainScreenModuleAssembly(),
        DetailsScreenModuleAssembly()
    ]
    
    lazy var appAssembler: Assembler = {
        $0.apply(assemblies: utilsAssemblies)
        $0.apply(assemblies: mainFlowAssemblies)
        return $0
    }(Assembler())
    
    lazy var resolver = appAssembler.resolver
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let coordinator = resolver.coordinatorResolverOwner.mainCoordinator()
        coordinator.start()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
    }
}
