//
//  DataSource.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 23.11.2023.
//

import Foundation
import UIKit
import UIKit

final class CarouselDataSource: NSObject, UICollectionViewDelegate {

    // MARK: - Typealias

    typealias DataSource = UICollectionViewDiffableDataSource<Models.Section, Models.Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Models.Section, Models.Item>

    // MARK: - Private Properties

    private let collectionView: UICollectionView
    private lazy var dataSource = makeDataSource()
    
    var pageSize: CGSize {
         let layout = self.collectionView.collectionViewLayout as! CarouselFlowLayout
         var pageSize = layout.itemSize
         if layout.scrollDirection == .horizontal {
             pageSize.width += layout.minimumLineSpacing
         } else {
             pageSize.height += layout.minimumLineSpacing
         }
         return pageSize
     }
    
    var input: Input?
    var output: Output?
    
    // MARK: - Init

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()

        setup()
        setupInput()
        registerReusable()
    }

    // MARK: - Private Methods

    private func setup() {
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.isUserInteractionEnabled = true
        collectionView.collectionViewLayout = makeCarouselLayout()
    }

    private func registerReusable() {
        collectionView.register(cellType: CarouselCollectionViewCell.self)
    }

    private func setupInput() {
        input = .init(
            onUpdateItems: { [weak self] in
                self?.updateData($0)
            }
        )
    }

    private func makeDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .item(let data):
                let cell: CarouselCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(data.book)
                return cell
            }
        }
    }

    // MARK: - Helper Methods

    private func updateData(_ items: [Book]) {
        updateSnapshot(makeItemsSection(items))
    }

    private func updateSnapshot(_ sections: [Models.Section], animated: Bool = true) {
        var snapshot = Snapshot()
        for section in sections {
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animated)
    }

    private func makeItemsSection(_ items: [Book]) -> [Models.Section] {
        [.init(items: mapItems(items), type: .items)]
    }

    private func mapItems(_ items: [Book]) -> [Models.Item] {
        items.map { .item(.init(book: $0)) }
    }

    // MARK: - Layou

    private func makeCarouselLayout() -> UICollectionViewFlowLayout {
        let layout = CarouselFlowLayout()
        layout.spacingMode = .fixed(spacing: 16)
    
        layout.itemSize = CGSize(width: Size.width * 0.532, height: Size.height * 0.375)
        layout.scrollDirection = .horizontal
        return layout
    }
}

extension CarouselDataSource: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = collectionView.collectionViewLayout as! CarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? pageSize.width : pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        let currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        output?.onWillDisplayItemIndex(currentPage)
    }
}

// MARK: - Models

extension CarouselDataSource {
    enum Models {
        struct Section: Hashable {
            let items: [Item]
            let type: SectionType
        }

        enum SectionType: Hashable {
            case items
        }

        enum Item: Hashable {
            case item(CarouselCollectionViewCell.CellData)
        }
    }
}

// MARK: - Input / Output

extension CarouselDataSource {
    struct Output {
        @MainThreadExecutable
        var onWillDisplayItemIndex: EventHandler<Int>
    }

    struct Input {
        var onUpdateItems: EventHandler<[Book]>
    }
}
