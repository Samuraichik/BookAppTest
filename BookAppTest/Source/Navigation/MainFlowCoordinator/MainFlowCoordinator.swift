//
//  MainFlowCoordinator.swift
//  Randm
//
//  Created by Oleksiy Humenyuk on 14.06.2022.
//

import Swinject
import StoreKit
import MessageUI

protocol AnyMainCoordinator: AnyCoordinator,
                             AnySplashScreenCoordinator,
                             AnyMainScreenCoordinator,
                             AnyDetailsScreenCoordinator {}

final class MainFlowCoordinator: NSObject, AnyMainCoordinator, InjectableViaInit, UINavigationControllerDelegate {
    typealias Dependencies = (
        AnyScreenResolverOwner,
        AnyCoordinatorResolverOwner,
        AnySystemResolverOwner
    )
    
    // MARK: - Public Properties
    
    let screenResolverOwner: AnyScreenResolverOwner
    
    // MARK: - Private Properties
    
    private let coordinatorResolverOwner: AnyCoordinatorResolverOwner
    private let systemResolverOwner: AnySystemResolverOwner
    
    // MARK: - Init
    
    init(dependencies: Dependencies) {
        (screenResolverOwner,
         coordinatorResolverOwner,
         systemResolverOwner) = dependencies
    }
    
    // MARK: - Public Methods
}

// MARK: - ICordinator

extension MainFlowCoordinator {
    public func start() {
        let window = systemResolverOwner.window
        window.makeKeyAndVisible()
        
        let controller = screenResolverOwner.splashScreen(with: self)
        let navController = UINavigationController(rootViewController: controller)
        
        navController.view.backgroundColor = .white
        window.rootViewController = navController
    }
    
}

// MARK: - AnySplashScreenCoordinator

extension MainFlowCoordinator {
    @MainActor
    func handle(event: SplashScreenCoordinatorEvent) {
        Task {
            switch event {
            case .onClose(let view):
                let controller = screenResolverOwner
                    .mainScreen(with: self)
                view?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}

// MARK: - AnyMainScreenCoordinator

extension MainFlowCoordinator {
    @MainActor
    func handle(event: MainScreenCoordinatorEvent) {
        Task {
            switch event {
            case .openDetailsScreen(let view, let rootModel, let bookId):
                
                let controller = screenResolverOwner
                    .detailsScreen(with: self, rootModel: rootModel, bookId: bookId)
                
                view?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}

// MARK: - AnyDetailsScreenCoordinator

extension MainFlowCoordinator {
    @MainActor
    func handle(event: DetailsScreenCoordinatorEvent) {
        Task {
            switch event {
            case .onClose(let view):
                view?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
