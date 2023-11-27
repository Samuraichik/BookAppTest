//
//  DetailsScreenMainView.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 23.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class DetailsScreenMainView: BaseInteractiveView {
    // MARK: - Public Properties
    
    let readNowButton: UIButton = {
        $0.setupContent(
            .attributedText(
                text: Rswift.strings.detailsReadNowButtonText(),
                color: .white,
                font: Rswift.font.nunitoSansExtraBold(size: 16)
            )
        )
        $0.backgroundColor = Rswift.colors.otherButtonColor()
        $0.layer.cornerRadius = 24
        return $0
    }(UIButton())
    
    let detailsInfoView: DetailsInfoView = {
        $0.backgroundColor = .clear
        return $0
    }(DetailsInfoView())
    
    let carouselCollectionView: UICollectionView = {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isUserInteractionEnabled = true
        $0.isPagingEnabled = false
        $0.decelerationRate = .fast
        $0.clipsToBounds = true
        $0.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: .init()))
    
    let recommendedCollectionView: UICollectionView = {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isUserInteractionEnabled = true
        $0.isPagingEnabled = false
        $0.decelerationRate = .fast
        $0.clipsToBounds = true
        $0.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: .init()))
    
    lazy var summaryDescriptionTextLabel: UILabel = {
        $0.apply(
            Rswift.font.nunitoSansSemiBold(size: 14),
            color: Rswift.colors.otherMainText2(),
            numberOfLines: 0,
            alignment: .left,
            text: ""
        )
        return $0
    }(UILabel())
    
    lazy var bookDetailsContainer: UIView = {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.masksToBounds = true
        return $0
    }(UIView())
    
    lazy var scrollView: UIScrollView = {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.scrollIndicatorInsets = safeAreaInsets
        $0.contentInset = .zero
        $0.bounces = true
        return $0
    }(UIScrollView())
    
    // MARK: - Private Properties
    
    private lazy var summaryTextLabel: UILabel = {
        $0.apply(
            Rswift.font.nunitoSansBold(size: 20),
            color: Rswift.colors.otherMainText(),
            numberOfLines: 1,
            alignment: .left,
            text: Rswift.strings.detailsSummaryText()
        )
        return $0
    }(UILabel())
    
    private lazy var youWillAlsoLikeLabel: UILabel = {
        $0.apply(
            Rswift.font.nunitoSansBold(size: 20),
            color: Rswift.colors.otherMainText(),
            numberOfLines: 1,
            alignment: .left,
            text: Rswift.strings.detailsAlsoLikeText()
        )
        return $0
    }(UILabel())
    
    private lazy var carouselContainerView = UIView()
        
    private lazy var backgroundImage: UIImageView = {
        $0.image = Rswift.images.carouselCollectionBackground()
        $0.contentMode = .scaleToFill
        return $0
    }(UIImageView())
    
    private lazy var separatorView: UIView = {
        $0.backgroundColor = Rswift.colors.otherDisabledColor()
        return $0
    }(UIView())
    
    // MARK: - Lifecycle
    
    override func addViews() {
        super.addViews()
        addSubviews([backgroundImage, scrollView])
        scrollView.addSubviews([
            carouselContainerView,
            carouselCollectionView,
            bookDetailsContainer
        ])
        
        bookDetailsContainer.addSubviews([
            detailsInfoView,
            summaryTextLabel,
            summaryDescriptionTextLabel,
            separatorView,
            youWillAlsoLikeLabel,
            recommendedCollectionView,
            readNowButton
        ])
    }

    override func anchorViews() {
        super.anchorViews()
        inactiveConstraints.append(contentsOf: prepareBackgroundImageConstraints())
        inactiveConstraints.append(contentsOf: prepareScrollViewViewConstraints())
        inactiveConstraints.append(contentsOf: prepareCarouselContainerViewConstraints())
        inactiveConstraints.append(contentsOf: prepareCarouselCollectionViewConstraints())
        inactiveConstraints.append(contentsOf: prepareBookDetailsContainerConstraints())
        inactiveConstraints.append(contentsOf: prepareSummaryTextLabelConstraints())
        inactiveConstraints.append(contentsOf: prepareSummaryDescriptionTextLabelConstraints())

        inactiveConstraints.append(contentsOf: prepareDetailsInfoViewConstraints())
        inactiveConstraints.append(contentsOf: prepareSeparatorViewConstraints())
        inactiveConstraints.append(contentsOf: prepareYouWillAlsoLikeLabelConstraints())
        inactiveConstraints.append(contentsOf: prepareWillLikeCollectionViewConstraints())
        inactiveConstraints.append(contentsOf: prepareReadNowButtonConstraints())
    }
}

private extension DetailsScreenMainView {
    // MARK: - Private Methods
    
    func prepareReadNowButtonConstraints() -> [Constraint] {
        readNowButton.snp.prepareConstraints {
            $0.top.equalTo(recommendedCollectionView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(self.snp.height).multipliedBy(0.06)
            $0.leading.trailing.equalToSuperview().inset(48)
            $0.bottom.equalToSuperview().offset(-85)
        }
    }
    
    func prepareWillLikeCollectionViewConstraints() -> [Constraint] {
        recommendedCollectionView.snp.prepareConstraints {
            $0.top.equalTo(youWillAlsoLikeLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Size.height*0.233)
        }
    }
    
    func prepareBookDetailsContainerConstraints() -> [Constraint] {
        bookDetailsContainer.snp.prepareConstraints {
            $0.top.equalTo(carouselContainerView.snp.bottom)
            $0.leading.trailing.equalTo(self)
            $0.bottom.equalTo(scrollView)
        }
    }
    
    func prepareBackgroundImageConstraints() -> [Constraint] {
        backgroundImage.snp.prepareConstraints {
            $0.trailing.leading.bottom.top.equalToSuperview()
        }
    }
    
    func prepareDetailsInfoViewConstraints() -> [Constraint] {
        detailsInfoView.snp.prepareConstraints {
            $0.top.equalTo(bookDetailsContainer.snp.top).offset(21)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(45)
        }
    }
    
    func prepareYouWillAlsoLikeLabelConstraints() -> [Constraint] {
        youWillAlsoLikeLabel.snp.prepareConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(22)
         }
    }
    
    func prepareSeparatorViewConstraints() -> [Constraint] {
        separatorView.snp.prepareConstraints {
            $0.top.equalTo(summaryDescriptionTextLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(1)
         }
    }
    
    func prepareSummaryDescriptionTextLabelConstraints() -> [Constraint] {
        summaryDescriptionTextLabel.snp.prepareConstraints {
            $0.top.equalTo(summaryTextLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
         }
    }
    
    func prepareSummaryTextLabelConstraints() -> [Constraint] {
        summaryTextLabel.snp.prepareConstraints {
            $0.top.equalTo(detailsInfoView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(22)
         }
    }
    
    func prepareScrollViewViewConstraints() -> [Constraint] {
        scrollView.snp.prepareConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func prepareCarouselContainerViewConstraints() -> [Constraint] {
        carouselContainerView.snp.prepareConstraints {
            $0.top.equalTo(scrollView)
            $0.left.right.equalTo(self)
            $0.height.equalTo(Size.height * 0.38)
            $0.bottom.lessThanOrEqualTo(scrollView)
        }
    }
    
    func prepareCarouselCollectionViewConstraints() -> [Constraint] {
        carouselCollectionView.snp.prepareConstraints {
            $0.left.right.equalTo(carouselContainerView)
            $0.top.equalTo(carouselContainerView).priority(.high)
            $0.height.greaterThanOrEqualTo(carouselContainerView.snp.height).priority(.required)
            $0.bottom.equalTo(carouselContainerView.snp.bottom)
        }
    }
}
