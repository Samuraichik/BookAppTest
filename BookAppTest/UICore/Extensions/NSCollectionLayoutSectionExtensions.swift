//
//  NSCollectionLayoutSectionExtensions.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 21.11.2023.
//

import Foundation
import UIKit

extension NSCollectionLayoutSection {
    
    // MARK: - Builder
    
    final class Builder {
        private var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior?
        private var groupSize: NSCollectionLayoutSize?
        
        private var sectionContentInset: NSDirectionalEdgeInsets?
        private var groupContentInset: NSDirectionalEdgeInsets?
        private var itemContentInset: NSDirectionalEdgeInsets?
        private var boundarySupplementaryItems: NSCollectionLayoutBoundarySupplementaryItem?
        
        private var isGroupHorizontal: Bool = true
        private var groupCount: Int = 1
        
        // MARK: - Calculated properties
        
        private lazy var itemSize = {
            NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        }()
        
        private lazy var item = { () -> NSCollectionLayoutItem in
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            if let contentInset = itemContentInset {
                item.contentInsets = contentInset
            }
            
            return item
        }()
        
        private lazy var group = { () -> NSCollectionLayoutGroup in
            let group = isGroupHorizontal ?
            NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize!,
                repeatingSubitem: item,
                count: groupCount
            ) :
            NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize!,
                repeatingSubitem: item,
                count: groupCount
            )
            
            group.interItemSpacing = .fixed(spacing)
            
            if let contentInset = groupContentInset {
                group.contentInsets = contentInset
            }
            
            return group
        }()
        
        private lazy var headerSize = { () -> NSCollectionLayoutSize in
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
            return headerSize
        }()
                
        private lazy var spacing = {
            CGFloat(10)
        }()
        
        private lazy var section = { () -> NSCollectionLayoutSection in
            let section = NSCollectionLayoutSection(group: group)
            
            if let contentInset = sectionContentInset {
                section.contentInsets = contentInset
            }
            
            section.interGroupSpacing = spacing
            
            if let orthogonalScrollingBehavior = orthogonalScrollingBehavior {
                section.orthogonalScrollingBehavior = orthogonalScrollingBehavior
            }
    
            return section
        }()
        
        // MARK: - Setters
        
        @discardableResult
        func setOrthogonalScrollingBehavior (behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior) -> Self {
            orthogonalScrollingBehavior = behavior
            
            return self
        }

        @discardableResult
        func setGroupSize(widthDimension: NSCollectionLayoutDimension, heightDimension: NSCollectionLayoutDimension) -> Self {
            groupSize = NSCollectionLayoutSize(widthDimension: widthDimension, heightDimension: heightDimension)
            
            return self
        }
        
        @discardableResult
        func setSectionContentInset(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) -> Self {
            sectionContentInset = NSDirectionalEdgeInsets(
                top: top,
                leading: leading,
                bottom: bottom,
                trailing: trailing
            )
            
            return self
        }
        
        @discardableResult
        func setGroupContentInset(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) -> Self {
            groupContentInset = NSDirectionalEdgeInsets(
                top: top,
                leading: leading,
                bottom: bottom,
                trailing: trailing
            )
            
            return self
        }
        
        @discardableResult
        func setItemContentInset(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) -> Self {
            itemContentInset = NSDirectionalEdgeInsets(
                top: top,
                leading: leading,
                bottom: bottom,
                trailing: trailing
            )
            
            return self
        }
        
        @discardableResult
        func setHeaderSize(size: NSCollectionLayoutSize) -> Self {
            headerSize = size
            
            return self
        }
        
        @discardableResult
        func isGroupHorizontal(horizontal: Bool) -> Self {
            isGroupHorizontal = horizontal
            
            return self
        }
        
        @discardableResult
        func setGroupCount(count: Int) -> Self {
            groupCount = count
            
            return self
        }

        // MARK: - Build
        
        func build() -> NSCollectionLayoutSection { section }
    }
}
