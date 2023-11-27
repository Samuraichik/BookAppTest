//
//  UINavigationController.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 26.11.2023.
//

import Foundation
import UIKit

public extension UINavigationController {
    func applyDefaultNavBarAppearance() {
        let standartAppearance = UINavigationBarAppearance()
        standartAppearance.configureWithOpaqueBackground()
        standartAppearance.shadowColor = .clear
        standartAppearance.shadowImage = UIImage()
        standartAppearance.backgroundColor = .clear
 
        navigationBar.standardAppearance = standartAppearance
        navigationBar.scrollEdgeAppearance = standartAppearance
    }
    
    func setUpBackButton(button: UIBarButtonItem?) {
        button?.tintColor = .white
        button?.imageInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }
}
