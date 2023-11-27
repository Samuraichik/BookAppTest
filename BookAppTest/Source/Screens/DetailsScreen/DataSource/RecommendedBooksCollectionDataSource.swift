//
//  WillLikeCollectionDataSource.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 24.11.2023.
//

import Foundation
import UIKit

final class RecommendedBooksCollectionDataSource: NSObject, UICollectionViewDelegate {

    // MARK: - Typealias

    typealias DataSource = UICollectionViewDiffableDataSource<Models.Section, Models.Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Models.Section, Models.Item>

    // MARK: - Private Properties

    private let collectionView: UICollectionView
    private lazy var dataSource = makeDataSource()

    var input: Input?

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
        collectionView.isUserInteractionEnabled = true
        collectionView.delegate = self
        collectionView.collectionViewLayout = makeDefaultLayout()
    }

    private func registerReusable() {
        collectionView.register(cellType: BookCollectionViewCell.self)
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
                let cell: BookCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(data, bookNameColor: Rswift.colors.otherMainText2()!)
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

    // MARK: - Layout

    private func makeDefaultLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8

        layout.itemSize = CGSize(width: Size.width * 0.32, height: collectionView.bounds.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        return layout
     }
}

// MARK: - Models

extension RecommendedBooksCollectionDataSource {
    enum Models {
        struct Section: Hashable {
            let items: [Item]
            let type: SectionType
        }

        enum SectionType: Hashable {
            case items
        }

        enum Item: Hashable {
            case item(BookCollectionViewCell.CellData)
        }
    }
}

// MARK: - Input / Output

extension RecommendedBooksCollectionDataSource {
    struct Input {
        var onUpdateItems: EventHandler<[Book]>
    }
}
