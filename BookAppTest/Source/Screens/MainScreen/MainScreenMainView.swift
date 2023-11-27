//
//  MainScreenMainView.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 21.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class MainScreenMainView: BaseInteractiveView {
    // MARK: - Public Properties
    
    let mainCollectionView: UICollectionView = {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.bounces = false
        $0.isUserInteractionEnabled = true
        $0.isPagingEnabled = false
        $0.decelerationRate = .normal
        $0.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: .init()))
    
    let pageControl: UIPageControl = {
        $0.isHidden = true
        $0.isUserInteractionEnabled = false
        $0.hidesForSinglePage = true
        $0.currentPage = 0
        $0.pageIndicatorTintColor = Rswift.colors.dark300()
        $0.currentPageIndicatorTintColor = Rswift.colors.accentMainColor()
        return $0
    }(UIPageControl())
    
    private lazy var libraryLabel: UILabel = {
        $0.apply(
            Rswift.font.nunitoSansBold(size: 20),
            color: Rswift.colors.accentMainColor(),
            text: Rswift.strings.mainLibraryText()
        )
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.adjustsFontForContentSizeCategory = true
        return $0
    }(UILabel())
    
    // MARK: - Lifecycle
    
    override func addViews() {
        super.addViews()
        addSubviews([
            mainCollectionView,
            libraryLabel
        ])
        mainCollectionView.addSubview(pageControl)
    }
    
    override func anchorViews() {
        super.anchorViews()
        inactiveConstraints.append(contentsOf: prepareLibraryLabelConstraints())
        inactiveConstraints.append(contentsOf: prepareCollectionViewConstraints())
        inactiveConstraints.append(contentsOf: preparePageControlConstraints())
    }
}

private extension MainScreenMainView {
    // MARK: - Private Methods

    func preparePageControlConstraints() -> [Constraint] {
        pageControl.snp.prepareConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(10)
            $0.width.equalTo(pageControl.size(forNumberOfPages: 6).width)
            $0.top.equalTo(mainCollectionView.snp.top).offset(120/667*Size.height)
        }
    }
    
    func prepareLibraryLabelConstraints() -> [Constraint] {
        libraryLabel.snp.prepareConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(18)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(22)
        }
    }
    
    func prepareCollectionViewConstraints() -> [Constraint] {
        mainCollectionView.snp.prepareConstraints {
            $0.top.equalTo(libraryLabel.snp.bottom).offset(28)
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
        }
    }
}
