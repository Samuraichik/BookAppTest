//
//  BookCollectionViewCell.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 22.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class BookCollectionViewCell: BaseInteractiveCollectionViewCell, Reusable {
    
    private lazy var  bookImage: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())
    
    private lazy var  bookName: UILabel = {
        $0.numberOfLines = 0
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    override func addViews() {
        contentView.addSubviews([
            bookName,
            bookImage
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
    }

    override func anchorViews() {
        inactiveConstraints.append(contentsOf: makebookImageConstraints())
        inactiveConstraints.append(contentsOf: makebookNameConstraints())
    }
    
    override func configureViews() {
        backgroundColor = .clear
    }
    
    private func makebookImageConstraints() -> [Constraint] {
        bookImage.snp.prepareConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bookName.snp.top).offset(-4)
        }
    }
    
    private func makebookNameConstraints() -> [Constraint] {
        bookName.snp.prepareConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(36)
        }
    }
    
    // MARK: - Configure Methods
    
    func configureCell(_ data: CellData, bookNameColor: UIColor) {
        bookName.apply(
            text: data.book.name,
            with: [
                .font: Rswift.font.nunitoSansRegular(size: 16)!,
                .foregroundColor: bookNameColor,
                .paragraphStyle: NSParagraphStyle.makeNewStyle(with: 0.81)
            ]
        )
        bookImage.kf.setImage(
            with: URL(string: data.book.coverURL),
            placeholder: Rswift.images.placeholderImage()
        )
    }
}

// MARK: - CellData

extension BookCollectionViewCell {
    struct CellData: Identifiable, Equatable, Hashable {
        let id: UUID = UUID()
        let book: Book
        
        static func == (lhs: BookCollectionViewCell.CellData, rhs: BookCollectionViewCell.CellData) -> Bool {
            lhs.id == rhs.id
        }
    }
}
