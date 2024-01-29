//
//  UICollectionViewExtensions.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 21.11.2023.
//

import Foundation
import UIKit

extension UICollectionView {
    @discardableResult
    final func register<T: UICollectionViewCell>(cellType: T.Type) -> Self where T: Reusable {
        register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
        return self
    }
    
    @discardableResult
    final func register<T: UICollectionReusableView>(supplementaryViewType: T.Type, ofKind elementKind: String) -> Self where T: Reusable {
        register(
            supplementaryViewType.self,
            forSupplementaryViewOfKind: elementKind,
            withReuseIdentifier: supplementaryViewType.reuseIdentifier
        )
        
        return self
    }
    
    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T where T: Reusable {
        let bareCell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath)
        
        guard let cell = bareCell as? T else { fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier)") }
        
        return cell
    }
    
    final func dequeueReusableSupplementaryView<T: UICollectionReusableView> (
        ofKind elementKind: String,
        for indexPath: IndexPath,
        viewType: T.Type = T.self
    ) -> T where T: Reusable {
        let view = dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: viewType.reuseIdentifier,
            for: indexPath
        )
        
        guard let typedView = view as? T else {
            fatalError("Failed to dequeue a supplementary view with identifier \(viewType.reuseIdentifier)")
        }
        
        return typedView
    }
}

