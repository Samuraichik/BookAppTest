//
//  UILabelExtensions.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 22.11.2023.
//

import UIKit

extension UILabel {
    @discardableResult
    func apply(
        _ font: UIFont?,
        color: UIColor?,
        numberOfLines: Int = .zero,
        alignment: NSTextAlignment = .center,
        text: String
    ) -> Self {
        self.numberOfLines = numberOfLines
        self.font = font
        textColor = color ?? .black
        textAlignment = alignment
        self.text = text
        return self
    }

    @discardableResult
    func apply(text: String, with attributes: [NSAttributedString.Key : Any]) -> Self {
        let text = NSAttributedString(string: text, attributes: attributes)

        self.attributedText = text

        return self
    }
}

public extension NSParagraphStyle {
    static func makeNewStyle(with lineHeightMultiple: CGFloat) -> NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = lineHeightMultiple
        
        return style
    }
}
