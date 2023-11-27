//
//  DetailsScreenViewModel.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 23.11.2023.
//

import UIKit

// MARK: - AnyDetailsScreenCoordinator

enum DetailsScreenCoordinatorEvent {
    case onClose(view: UIViewController?)
}

protocol AnyDetailsScreenCoordinator {
    func handle(event: DetailsScreenCoordinatorEvent)
}

// MARK: - AnyDetailsScreenViewModel Output & Input

struct DetailsScreenVMOutput: AnyOutput {
    @MainThreadExecutable var dataFetched: EventHandler<([Book], [Book])>
    @MainThreadExecutable var currentBookUpdated: EventHandler<Book>
}

struct DetailsScreenVMInput: AnyInput {
    let onViewDidLoad: VoidClosure
    let carouselWillShowItem: EventHandler<Int>
    let backButtonTapped: EventHandler<UIViewController>
}

protocol AnyDetailsScreenViewModel: AnyViewModel where Input == DetailsScreenVMInput, Output == DetailsScreenVMOutput{
    var rootModel: RootModel { get }
}

// MARK: - DetailsScreenViewModel

final class DetailsScreenViewModel: InjectableViaInit, AnyDetailsScreenViewModel {
    typealias Dependencies = (
        AnyDetailsScreenCoordinator,
        RootModel,
        Int
    )
    
    // MARK: - Public Properties
    
    private(set) var input: DetailsScreenVMInput?
    var output: DetailsScreenVMOutput?
    var rootModel: RootModel
    let selectedBookId: Int

    // MARK: - Private Properties
    
    private var recommendedBooks: [Book] = []
    private var carouselBooks: [Book] = []
    private var currentIndex: Int?
    private let coordinator: AnyDetailsScreenCoordinator

    // MARK: - Init
    
    init(dependencies: Dependencies) {
        (coordinator,
         rootModel,
         selectedBookId) = dependencies
        setupInput()
    }
    
    // MARK: - Private Functions
    
    private func setupInput() {
        input = .init(
            onViewDidLoad: { [weak self] in
                self?.onViewDidLoadHandling()
            },
            carouselWillShowItem: { [weak self] in
                self?.handleCurrentBookChanging(currentIndex: $0)
            },
            backButtonTapped: { [weak self] in
                self?.coordinator.handle(event: .onClose(view: $0))
            }
        )
    }
    
    private func onViewDidLoadHandling() {
        guard let specialBook = rootModel.books.first(where: { $0.id == selectedBookId }) else { return }
        carouselBooks = [specialBook] + rootModel.books.filter { $0.id != selectedBookId }
        
        rootModel.youWillLikeSection.forEach {
            if let recommendedBook = rootModel.books[safe: $0] {
                recommendedBooks.append(recommendedBook)
            }
        }
        output?.dataFetched((carouselBooks, recommendedBooks))
    }
    
    private func handleCurrentBookChanging(currentIndex: Int) {
        self.currentIndex = currentIndex
        guard let currentBook = carouselBooks[safe: currentIndex] else { return }
        
        output?.currentBookUpdated(currentBook)
    }
}
