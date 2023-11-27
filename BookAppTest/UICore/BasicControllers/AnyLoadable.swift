//
//  AnyLoadable.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 22.11.2023.
//

import Foundation
import UIKit

public protocol AnyLoadable {
    func showLoader(_ completion: (() -> Void)?)
    func hideLoader(_ completion: (() -> Void)?)}

public extension AnyLoadable where Self: UIViewController {
    func showLoader(_ completion: (() -> Void)? = nil) {
//        navigationController?.navigationBar.isHidden = true
        view.showLoaderView()
        completion?()
    }
    
    func hideLoader(_ completion: (() -> Void)? = nil) {
//        self.navigationController?.navigationBar.isHidden = false
        self.view.hideLoaderView()
        completion?()
    }
}
