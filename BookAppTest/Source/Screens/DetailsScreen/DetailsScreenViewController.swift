//
//  DetailsScreenViewController.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 23.11.2023.
//

import UIKit

final class DetailsScreenViewController: BaseMainController<DetailsScreenMainView>, InjectableViaFunc {
    typealias Dependencies = DetailsScreenViewModel
    
    // MARK: - InjectableViaFunc
    
    func inject(dependencies: Dependencies) {
        viewModel = dependencies
    }
    
    // MARK: - Private Properties
    
    private var viewModel: DetailsScreenViewModel?
    
    private lazy var carouselBooksDataSource = CarouselDataSource(collectionView: mainView.carouselCollectionView)
    private lazy var recommendedBooksDataSource = RecommendedBooksCollectionDataSource(collectionView: mainView.recommendedCollectionView)
    
    private var previousStatusBarHidden = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutput()
        setupCarouselDataSourceOutput()
        viewModel?.input?.onViewDidLoad()
        mainView.scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    // MARK: - Private Methods
    
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Rswift.images.backButton(),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationController?.setUpBackButton(button: navigationItem.leftBarButtonItem)
        navigationController?.applyDefaultNavBarAppearance()
    }
    
    private func setupOutput() {
        viewModel?.output = .init(
            dataFetched: .init { [weak self] in
                guard let self = self, let firstBook = $0.0.first else { return }
                carouselBooksDataSource.input?.onUpdateItems($0.0)
                recommendedBooksDataSource.input?.onUpdateItems($0.1)
                updateScreenData(with: firstBook)
            },
            currentBookUpdated: .init { [weak self] in
                self?.updateScreenData(with: $0)
            }
        )
    }
    
    private func setupCarouselDataSourceOutput() {
        carouselBooksDataSource.output = .init(
            onWillDisplayItemIndex: .init { [unowned self] in
                viewModel?.input?.carouselWillShowItem($0)
            }
        )
    }
    
    private func updateScreenData(with book: Book) {
        mainView.summaryDescriptionTextLabel.text = book.summary
        mainView.detailsInfoView.setUpView(data: book)
    }
    
    //MARK: - Status Bar Appearance

    @objc private func backButtonTapped(_ sender: UIButton) {
        viewModel?.input?.backButtonTapped(self)
    }
}

extension DetailsScreenViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
        }
    }
}
