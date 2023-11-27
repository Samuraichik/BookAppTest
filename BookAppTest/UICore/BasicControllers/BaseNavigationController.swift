//
//  BaseNavigationController.swift
//  Rococo
//
//  Created by oleksiy humenyuk on 15.08.2023.
//

import UIKit

open class BaseNavigationController: UINavigationController {
    // MARK: - Lifecycle
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationBar.frame = CGRect(
            x: navigationBar.frame.minX,
            y: navigationBar.frame.minY,
            width: view.frame.width,
            height: 50 + additionalSafeAreaInsets.top
        )
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
