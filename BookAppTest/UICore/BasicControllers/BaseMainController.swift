//
//  BaseMainController.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import SnapKit
import UIKit

open class BaseMainController<View: BaseInteractiveView>: UIViewController,
                                                          UIViewControllerTransitioningDelegate,
                                                          AnyBaseControllerLifecycle,
                                                          AnyLoadable {
    
    // MARK: - Private Properties
    
    private(set) var wasShownAtLeastOnce = false
    
    // MARK: - Public Properties

    open var isNeedToHideNavBarOnDismiss = true
    open var mainView: View

    // MARK: - Inits

    public init(view: View = View()) {
        self.mainView = view
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("required init not implemented")
    }

    // MARK: - Life Cycle

    open override func loadView() {
        super.loadView()
        mainView.frame = view.frame
        view = mainView
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if wasShownAtLeastOnce {
            viewWillAppearAgain()
        } else {
            viewWillAppearAtFirstTime()
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if wasShownAtLeastOnce {
            viewDidAppearAgain()
        } else {
            viewDidAppearAtFirstTime()
        }

        wasShownAtLeastOnce = true
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isNeedToHideNavBarOnDismiss {
            navigationController?.setNavigationBarHidden(true, animated: true)
            isNeedToHideNavBarOnDismiss = false
        }
    }

    // MARK: - Public Methods

    open func viewWillAppearAtFirstTime() {
        configureUI()
        configureActions()
    }
}
