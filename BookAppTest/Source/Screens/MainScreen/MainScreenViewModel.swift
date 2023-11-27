//
//  MainScreenViewModel.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 21.11.2023.
//

import UIKit

// MARK: - AnyMainScreenCoordinator

enum MainScreenCoordinatorEvent {
    case openDetailsScreen(view: UIViewController?, rootModel: RootModel, bookId: Int)
}

protocol AnyMainScreenCoordinator {
    func handle(event: MainScreenCoordinatorEvent)
}

// MARK: - AnyMainScreenViewModel Output & Input

struct MainScreenVMOutput: AnyOutput {
    @MainVoidThreadExecutable var asyncActionDidStart: VoidClosure
    @MainVoidThreadExecutable var asyncActionDidEnd: VoidClosure
    
    @MainThreadExecutable var booksFetched: EventHandler<RootModel>
    @MainVoidThreadExecutable var timerUpdate: VoidClosure
}

struct MainScreenVMInput: AnyInput {
    let onViewDidLoad: EventHandler<UIViewController?>
    let onTappedBannerItem: EventHandler<(UIViewController?, TopBannerSlide)>
    let onTappedBookItem: EventHandler<(UIViewController?,Book)>
}

protocol AnyMainScreenViewModel: AnyViewModel where Input == MainScreenVMInput, Output == MainScreenVMOutput{}

// MARK: - MainScreenViewModel

final class MainScreenViewModel: InjectableViaInit, AnyMainScreenViewModel {
    typealias Dependencies = (
        AnyMainScreenCoordinator,
        AnyFirebaseService
    )
    
    // MARK: - Public Properties
    
    private(set) var input: MainScreenVMInput?
    var output: MainScreenVMOutput?
    private let firebaseService: AnyFirebaseService
    
    private var rootModel: RootModel?
    
    private(set) lazy var timer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource(queue: .main)
        
        timer.setEventHandler { [weak self] in
            self?.output?.timerUpdate()
        }
        
        return timer
    }()
    
    // MARK: - Private Properties
    
    private let coordinator: AnyMainScreenCoordinator

    // MARK: - Init
    
    init(dependencies: Dependencies) {
        (coordinator,
         firebaseService) = dependencies
        setupInput()
    }

    // MARK: - Private Functions
    
    private func setupInput() {
        input = .init(
            onViewDidLoad: { [weak self] in
                self?.fetchBooks(view: $0)
            },
            onTappedBannerItem: { [weak self] in
                self?.handleBannerItemTapping(view: $0.0, banner: $0.1)
            },
            onTappedBookItem: { [weak self] in
                self?.handleBookItemTapping(view: $0.0, book: $0.1)
            }
        )
    }
    
    private func fetchBooks(view: UIViewController?) {
        output?.asyncActionDidStart()
        Task {
            switch await firebaseService.fetchBooks() {
            case .success(let result):
                self.rootModel = result
                self.output?.booksFetched(result)
            case .failure(let failure):
                print(failure)
            }
            self.startAutomaticBannerScroll()
            self.output?.asyncActionDidEnd()
        }
    }
    
    private func startAutomaticBannerScroll() {
        timer.schedule(deadline: .now(), repeating: 3.0)
        timer.resume()
    }
    
    private func handleBannerItemTapping(view: UIViewController?, banner: TopBannerSlide) {
        guard let rootModel = rootModel else { return }
        coordinator.handle(event: .openDetailsScreen(view: view, rootModel: rootModel, bookId: banner.bookID))
    }
    
    private func handleBookItemTapping(view: UIViewController?, book: Book) {
        guard let rootModel = rootModel else { return }
        coordinator.handle(event: .openDetailsScreen(view: view, rootModel: rootModel, bookId: book.id))
    }
}
