//
//  MainDataSource.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 22.11.2023.
//

import Foundation
import UIKit

final class MainDataSource: NSObject {
    typealias DataSource = UICollectionViewDiffableDataSource<Models.Section, Models.Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Models.Section, Models.Item>
    
    typealias BookCellData = BookCollectionViewCell.CellData
    typealias BannerCellData = TopBannersCollectionViewCell.CellData
    
    var input: Input?
    var output: Output?
    
    private let collectionView: UICollectionView
    private lazy var dataSource = makeDataSource()
    
    private var currentBannerIndex = 5000
    
    private let bannerItemCount = 10000
    private var bannerItems: [BannerCellData] = []
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        
        setup()
        setupInput()
        registerReusable()
    }
    
    private func setupInput() {
        input = .init(
            onUpdateItems: .init { [weak self] in
                self?.processRootModel($0)
            },
            onScrollBanner: .init { [weak self] in
                self?.scrollToNextItemInBannerSection()
            }
        )
    }
    
    private func setup() {
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.collectionViewLayout = makeCollectionLayout()
    }
    
    private func registerReusable() {
        collectionView.register(cellType: TopBannersCollectionViewCell.self)
        collectionView.register(cellType: BookCollectionViewCell.self)
        
        collectionView.register(
             HeaderView.self,
             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
             withReuseIdentifier: HeaderView.reuseIdentifier
         )
    }
}

// MARK: - DataSouce.Snapshot

private extension MainDataSource {
    func processRootModel(_ root: RootModel) {
        var booksByGenre: [String: [Book]] = [:]
        for book in root.books {
            booksByGenre[book.genre, default: []].append(book)
        }

        var sections: [Models.Section] = []
        for (genre, books) in booksByGenre {
            let items = books.map { Models.Item.book(BookCellData(book: $0)) }
            let section = Models.Section(items: items, type: .init(rawValue: genre)!)
            sections.append(section)
        }

        if !root.topBannerSlides.isEmpty {
            bannerItems = root.topBannerSlides.map { BannerCellData(topBannerSlide: $0) }

            let bannerSectionItems = (0..<bannerItemCount).map { index in
                Models.Item.banner(bannerItems[index % bannerItems.count], UUID())
            }

            let bannerSection = Models.Section(items: bannerSectionItems, type: .banner)
            sections.insert(bannerSection, at: 0)
        }

        updateSnapshot(sections)
    }

    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, item -> UICollectionViewCell? in
                  
            switch item {
            case .banner(let bannerData, _):
                let cell: TopBannersCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(bannerData)
                return cell
            case .book(let bookData):
                let cell: BookCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(bookData, bookNameColor: Rswift.colors.white70()!)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView, kind, indexPath) -> UICollectionReusableView? in

            guard kind == UICollectionView.elementKindSectionHeader else { return nil }

            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderView.reuseIdentifier,
                for: indexPath
            ) as? HeaderView

            let sectionType = self?.dataSource.sectionIdentifier(for: indexPath.section)?.type.rawValue
            header?.setTitle(titleText: sectionType ?? "")

            return header
        }
        
        return dataSource
    }
    
    // MARK: - Helper Methods
    
    func updateSnapshot(_ sections: [Models.Section], animated: Bool = true) {
        var snapshot = MainDataSource.Snapshot()
        
        for section in sections {
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animated) { [weak self] in
            self?.scrollToMiddleOfBannerSection()
        }
    }
    
    func updateData(_ items: RootModel) {
        processRootModel(items)
    }
}

// MARK: - Layout

private extension MainDataSource {
    func createSupplementaryView(
        collectionView: UICollectionView,
        kind: String,
        indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderView.reuseIdentifier,
            for: indexPath) as? HeaderView else {
                fatalError("Cannot create header view")
        }
        
        let sectionType = dataSource.sectionIdentifier(for: indexPath.row)?.type.rawValue
        supplementaryView.setTitle(titleText: sectionType ?? "")

        return supplementaryView
    }
    
    func makeCollectionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] (index: Int, _) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[index]
            
            switch section.type {
            case .banner:
                return self.createBannnerSectionLayout()
            case .science,
                 .fantasy,
                 .romance:
                return self.createBooksSectionLayout()
            }
        }
    }
    
    func scrollToMiddleOfBannerSection() {
        guard !bannerItems.isEmpty else { return }

        let middleIndex = (bannerItemCount / 2) - 1
        let bannerSectionIndex = 0
        let middleIndexPath = IndexPath(item: middleIndex, section: bannerSectionIndex)
        collectionView.scrollToItem(at: middleIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    func scrollToNextItemInBannerSection() {
        guard !bannerItems.isEmpty else { return }
        
        let nextIndex = currentBannerIndex
        currentBannerIndex += 1
        
        let bannerSectionIndex = 0
        let nextIndexPath = IndexPath(item: nextIndex, section: bannerSectionIndex)
        
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            options: .curveLinear,
            animations: { [weak self] in
                self?.collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
            },
            completion: nil)
    }
    
    func createBannnerSectionLayout() -> NSCollectionLayoutSection {
        let builder = NSCollectionLayoutSection.Builder()
        let section = builder.isGroupHorizontal(horizontal: true)
            .setGroupSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.243))
              .setGroupCount(count: 1)
              .setItemContentInset(top: 0, leading: 16, bottom: 0, trailing: 16)
              .setOrthogonalScrollingBehavior(behavior: .groupPaging)
              .setSectionContentInset(top: 0, leading: 0, bottom: 35, trailing: 0)
              .build()

        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, _, _ in
            guard let self = self else { return }
            let currentItem = visibleItems.last?.indexPath.row ?? 0
            currentBannerIndex = currentItem
            output?.onWillDisplayItemIndex((currentItem, bannerItems.count))
        }
        
        return section
    }

    func createBooksSectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = NSCollectionLayoutSection.Builder()
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    
        let section = sectionBuilder
            .setGroupSize(widthDimension: .fractionalWidth(0.323), heightDimension: .fractionalHeight(0.285))
            .setSectionContentInset(top: 0, leading: 16, bottom: 26, trailing: 16)
            .isGroupHorizontal(horizontal: true)
            .setGroupCount(count: 1)
            .setGroupContentInset(top: 0, leading: 0, bottom: 0, trailing: 0)
            .setOrthogonalScrollingBehavior(behavior: .groupPaging)
            .setHeaderSize(size: headerSize)
            .build()
        
        section.boundarySupplementaryItems = [header]
        return section
    }
}

// MARK: - Models

extension MainDataSource {
    enum Models {
        struct Section: Hashable {
            let items: [Item]
            let type: SectionType
        }
        
        enum SectionType: String, Hashable {
            case banner = ""
            case science = "Science"
            case romance = "Romance"
            case fantasy = "Fantasy"
        }

        enum Item: Hashable {
            case book(BookCellData)
            case banner(BannerCellData, UUID)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MainDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .book(let bookData):
            output?.onTappedBookItem(bookData.book)
        case .banner(let bannerData, _):
            output?.onTappedBannerItem(bannerData.topBannerSlide)
        }
    }
}

// MARK: - Input / Output

extension MainDataSource {
    struct Output {
        @MainThreadExecutable
        var onTappedBannerItem: EventHandler<TopBannerSlide>
        
        @MainThreadExecutable
        var onTappedBookItem: EventHandler<Book>

        
        @MainThreadExecutable
        var onWillDisplayItemIndex: EventHandler<(Int, Int)>
    }
    
    
    struct Input {
        @MainThreadExecutable
        var onUpdateItems: EventHandler<(RootModel)>
        
        @MainVoidThreadExecutable
        var onScrollBanner: VoidClosure
    }
}
