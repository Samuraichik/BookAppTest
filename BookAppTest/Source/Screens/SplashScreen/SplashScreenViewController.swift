//
//  SplashScreenViewController.swift
//  Rococo
//
//  Created by oleksiy humenyuk on 18.08.2023.
//

final class SplashScreenViewController: BaseMainController<SplashScreenMainView>, InjectableViaFunc {
    typealias Dependencies = SplashScreenViewModel
    
    // MARK: - InjectableViaFunc
    
    func inject(dependencies: Dependencies) {
        viewModel = dependencies
    }
    
    // MARK: - Private Properties

    private var viewModel: SplashScreenViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.input?.onViewDidLoad(self)
        setupOutput()
    }
    
    // MARK: - Private Methods
    func setupOutput() {
        viewModel?.output = .init(
            appWillEnterForeground: .init { [weak self] in
                self?.mainView.progressBar.restartAnimation()
            }
        )
    }
}
