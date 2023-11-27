//
//  SplashScreenViewModel.swift
//  Rococo
//
//  Created by oleksiy humenyuk on 18.08.2023.
//

import UIKit

// MARK: - AnySplashScreenCoordinator

enum SplashScreenCoordinatorEvent {
    case onClose(view: UIViewController?)
}

protocol AnySplashScreenCoordinator {
    func handle(event: SplashScreenCoordinatorEvent)
}

// MARK: - AnySplashScreenViewModel Output & Input

struct SplashScreenVMOutput: AnyOutput {
    @MainVoidThreadExecutable var appWillEnterForeground: VoidClosure
}

struct SplashScreenVMInput: AnyInput {
    let onViewDidLoad: EventHandler<UIViewController?>
}

protocol AnySplashScreenViewModel: AnyViewModel where Input == SplashScreenVMInput, Output == SplashScreenVMOutput{}

// MARK: - SplashScreenViewModel

final class SplashScreenViewModel: InjectableViaInit, AnySplashScreenViewModel {
    typealias Dependencies = (
        AnySplashScreenCoordinator,
        NotificationCenter
    )
    
    // MARK: - Public Properties
    
    private(set) var input: SplashScreenVMInput?
    var output: SplashScreenVMOutput?
    private let notificationCenter: NotificationCenter
    
    // MARK: - Private Properties
    
    private let coordinator: AnySplashScreenCoordinator

    // MARK: - Init
    
    init(dependencies: Dependencies) {
        (coordinator,
         notificationCenter) = dependencies
        setupInput()
        addObserver()
    }
    
    deinit {
        removeObserver()
    }
    
    private func removeObserver() {
        notificationCenter.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc fileprivate func willEnterForeground() {
        output?.appWillEnterForeground()
    }
    
    private func addObserver() {
        notificationCenter.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    // MARK: - Private Functions
    
    private func setupInput() {
        input = .init(
            onViewDidLoad: { [weak self] in
                self?.handleSplashDidLoad(view: $0)
            }
        )
    }
    
    private func handleSplashDidLoad(view: UIViewController?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.coordinator.handle(event: .onClose(view: view))
            self.removeObserver()
        }
    }
}
