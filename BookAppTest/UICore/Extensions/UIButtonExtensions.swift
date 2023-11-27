//
//  UIButtonExtensions.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 26.11.2023.
//

import Foundation
import UIKit
public extension UIButton {
    enum Content {
        case plainText(text: String)
        case attributedText(text: String, color: UIColor?, font: UIFont?)
        case image(image: UIImage?, insets: NSDirectionalEdgeInsets )
    }
    
    func setupContent(_ content: Content) {
        var config = UIButton.Configuration.plain()
        
        switch content {
        case .plainText(let text):
            config.title = text
        case .attributedText(let text, let color, let font):
            var container = AttributeContainer()
            
            container.font = font
            container.foregroundColor = color
            config.attributedTitle = .init(text, attributes: container)
        case .image(let image, let insets):
            config.image = image
            config.contentInsets = insets
        }
        
        configuration = config
    }
}

