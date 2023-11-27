//
//  UIStackView.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 24.11.2023.
//

import Foundation
import UIKit

extension UIStackView {
    @discardableResult
    func addArrangedSubviews(_ views: [UIView]) -> Self {
        views.forEach { addArrangedSubview($0) }

        return self
    }

    @discardableResult
    func removeArrangedSubviews() -> Self {
        arrangedSubviews.forEach { removeArrangedSubview($0) }

        return self
    }
}
