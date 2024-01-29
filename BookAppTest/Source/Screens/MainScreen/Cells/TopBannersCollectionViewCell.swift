//
//  TopBannersCell.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 22.11.2023.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class TopBannersCollectionViewCell: BaseInteractiveCollectionViewCell, Reusable {
    let bannerImage: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .yellow
        return $0
    }(UIImageView())
    
    override func addViews() {
        contentView.addSubviews([
            bannerImage
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
        layer.cornerRadius = 30
        layer.masksToBounds = true
    }
    
    override func anchorViews() {
        inactiveConstraints.append(contentsOf: makeBannerImageConstraints())
    }
    
    override func configureViews() {
        backgroundColor = .clear
    }
    
    private func makeBannerImageConstraints() -> [Constraint] {
        bannerImage.snp.prepareConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Configure Methods
    func configureCell(_ data: CellData) {
        self.bannerImage.kf.setImage(
            with: URL(string: data.topBannerSlide.cover),
            placeholder: Rswift.images.placeholderImage()
        )
    }
}

// MARK: - CellData

extension TopBannersCollectionViewCell {
    struct CellData: Identifiable, Equatable, Hashable {
        let id: UUID = UUID()
        let topBannerSlide: TopBannerSlide
        
        static func == (lhs: CellData, rhs: CellData) -> Bool {
            return lhs.id == rhs.id
        }
    }
}
