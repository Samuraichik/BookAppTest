//
//  AnyScreenResolverOwner.swift
//  BookAppTest
//
//  Created by Oleksiy Humenyuk on 21.11.2022.
//

import Swinject

protocol AnyScreenResolverOwner: AnyResolverOwner {
    func splashScreen(with flow: AnySplashScreenCoordinator) -> SplashScreenViewController
    func mainScreen(with flow: AnyMainScreenCoordinator) -> MainScreenViewController
    func detailsScreen(
        with flow: AnyDetailsScreenCoordinator,
        rootModel: RootModel,
        bookId: Int
    ) -> DetailsScreenViewController
}

extension AnyScreenResolverOwner {
    // MARK: - Main Flow

    func splashScreen(with flow: AnySplashScreenCoordinator) -> SplashScreenViewController {
        resolver.resolve(flow)!
    }
    
    func mainScreen(with flow: AnyMainScreenCoordinator) -> MainScreenViewController {
        resolver.resolve(flow)!
    }
    
    func detailsScreen(
        with flow: AnyDetailsScreenCoordinator,
        rootModel: RootModel,
        bookId: Int
    ) -> DetailsScreenViewController {
        resolver.resolve(flow, rootModel, bookId)!
    }
}
