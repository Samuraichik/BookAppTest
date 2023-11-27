//
//  CarouselCollectionViewCell.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 23.11.2023.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class CarouselCollectionViewCell: BaseInteractiveCollectionViewCell, Reusable {
    private lazy var bookImage: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())
    
    private lazy var bookName: UILabel = {
        $0.apply(
            Rswift.font.nunitoSansBold(size: 20),
            color: .white,
            text: Rswift.strings.mainLibraryText()
        )
        $0.numberOfLines = 1
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var  bookAuthor: UILabel = {
        $0.apply(
            Rswift.font.nunitoSansBold(size: 14),
            color: Rswift.colors.white80(),
            text: Rswift.strings.mainLibraryText()
        )
        $0.numberOfLines = 1
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    override func addViews() {
        contentView.addSubviews([
            bookName,
            bookImage,
            bookAuthor
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
    }
    
    override func anchorViews() {
        inactiveConstraints.append(contentsOf: makebookImageConstraints())
        inactiveConstraints.append(contentsOf: makebookNameConstraints())
        inactiveConstraints.append(contentsOf: makebookAuthorConstraints())
    }
    
    override func configureViews() {
        backgroundColor = .clear
    }
    
    private func makebookAuthorConstraints() -> [Constraint] {
        bookAuthor.snp.prepareConstraints {
            $0.top.equalTo(bookName.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-15)
            $0.height.equalTo(15)
        }
    }
    
    private func makebookImageConstraints() -> [Constraint] {
        bookImage.snp.prepareConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.equalTo(60)
        }
    }
    
    private func makebookNameConstraints() -> [Constraint] {
        bookName.snp.prepareConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(22)
            $0.top.equalTo(bookImage.snp.bottom).offset(16)
        }
    }
    
    // MARK: - Configure Methods
    func configureCell(_ data: Book) {
        bookName.text = data.name
        bookAuthor.text = data.author
        bookImage.kf.setImage(
            with: URL(string: data.coverURL),
            placeholder: Rswift.images.placeholderImage()
        )
    }
}

// MARK: - CellData

extension CarouselCollectionViewCell {
    struct CellData: Identifiable, Equatable, Hashable {
        let id: UUID = UUID()
        let book: Book
        
        static func == (lhs: CarouselCollectionViewCell.CellData, rhs: CarouselCollectionViewCell.CellData) -> Bool {
            lhs.id == rhs.id
        }
    }
}
