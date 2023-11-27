//
//  MainScreenViewController.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 21.11.2023.
//
import Foundation

final class MainScreenViewController: BaseMainController<MainScreenMainView>, InjectableViaFunc {
    typealias Dependencies = MainScreenViewModel
    
    // MARK: - InjectableViaFunc
    
    func inject(dependencies: Dependencies) {
        viewModel = dependencies
    }
    
    // MARK: - Private Properties

    private var viewModel: MainScreenViewModel?
    
    private lazy var mainBooksDataSource = MainDataSource(collectionView: mainView.mainCollectionView)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModelOutput()
        setupDataSourceOutput()
        configureView()
        viewModel?.input?.onViewDidLoad(self)
    }
}

private extension MainScreenViewController {
    // MARK: - Private Methods
    func setupViewModelOutput() {
        viewModel?.output = .init(
            asyncActionDidStart: .init { [weak self] in
                self?.showLoader()
            },
            asyncActionDidEnd: .init { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.hideLoader()
                }
            }, 
            booksFetched: .init { [weak self] in
                self?.mainView.pageControl.numberOfPages = $0.topBannerSlides.count > 6 ? 6 : $0.topBannerSlides.count
                self?.mainBooksDataSource.input?.onUpdateItems($0)
            },
            timerUpdate: .init { [weak self] in
                self?.mainBooksDataSource.input?.onScrollBanner()
            }
        )
    }
    
    func setupDataSourceOutput() {
        mainBooksDataSource.output = .init(
            onTappedBannerItem: .init { [weak self] in
                self?.viewModel?.input?.onTappedBannerItem((self,$0))
            },
            onTappedBookItem: .init { [weak self] in
                self?.viewModel?.input?.onTappedBookItem((self, $0))
            },
            onWillDisplayItemIndex: .init { [weak self] in
                let currentPage = $0.0 % $0.1
                self?.mainView.pageControl.currentPage = currentPage
            }
        )
    }
    
    func configureView() {
        mainView.backgroundColor = Rswift.colors.backgroundGray1000()
    }
}
