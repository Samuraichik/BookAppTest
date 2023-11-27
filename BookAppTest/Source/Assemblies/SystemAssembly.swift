//
//  SystemAssembly.swift
//  BookAppTest
//
//  Created by Oleksiy Humenyuk on 21.11.2022.
//

import Swinject
import UIKit
import FirebaseRemoteConfig

final class SystemAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UIApplication.self) { _ in
            UIApplication.shared
        }.inObjectScope(.container)
        
        container.register(AppDelegate.self) { resolver in
            let application = resolver.resolve(UIApplication.self)!
            return application.delegate as! AppDelegate
        }.inObjectScope(.container)

        container.register(SceneDelegate.self) { resolver in
            let application = resolver.resolve(UIApplication.self)!
            return application.connectedScenes.first!.delegate as! SceneDelegate
        }.inObjectScope(.container)

        container.register(UIWindow.self) { resolver in
            let sceneDelegate = resolver.resolve(SceneDelegate.self)!
            return sceneDelegate.window!
        }
        
        container.register(ResolverOwner.self) { resolver in
                .init(dependencies: resolver)
        }
        
        container.register(NotificationCenter.self) { _ in
            NotificationCenter.default
        }
        
        container.register(RemoteConfig.self) { _ in
            let remoteConfig = RemoteConfig.remoteConfig()
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = 0
            remoteConfig.configSettings = settings
            return remoteConfig
        }
    }
}
