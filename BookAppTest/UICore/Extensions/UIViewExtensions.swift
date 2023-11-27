//
//  UIViewExtensions.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 21.11.2023.
//

import Foundation
import UIKit

public extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    @discardableResult
    func showLoaderView() -> CoverLoaderView? {
        guard subviews.filter({ $0 is CoverLoaderView }).count == 0 else {
            return nil
        }

        let coverLoaderView = CoverLoaderView()
        addSubview(coverLoaderView)

        coverLoaderView.snp.makeConstraints {
            $0.size.equalToSuperview()
            $0.center.equalToSuperview()
        }

        return coverLoaderView
    }
        
    func hideLoaderView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 0.5) {
                self.subviews
                    .first(where: { ($0 as? CoverLoaderView) != nil })?
                    .removeFromSuperview()
            }
        }
    }
}
