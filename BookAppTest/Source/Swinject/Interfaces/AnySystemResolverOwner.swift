//
//  AnySystemResolverOwner.swift
//  BookAppTest
//
//  Created by Oleksiy Humenyuk on 21.11.2022.
//

import UIKit
import Swinject

protocol AnySystemResolverOwner: AnyResolverOwner {
    var application: UIApplication { get }
    var appDelegate: AppDelegate { get }
    var sceneDelegate: SceneDelegate { get }
    var window: UIWindow { get }
    var userDefaults: UserDefaults { get }
    var userNotificationCenter: UNUserNotificationCenter { get }

}

extension AnySystemResolverOwner {
    var application: UIApplication { resolver.resolve() }
    var appDelegate: AppDelegate { resolver.resolve() }
    var sceneDelegate: SceneDelegate { resolver.resolve() }
    var window: UIWindow { resolver.resolve() }
    var userDefaults: UserDefaults { resolver.resolve() }
    var userNotificationCenter: UNUserNotificationCenter { resolver.resolve()  }
}


