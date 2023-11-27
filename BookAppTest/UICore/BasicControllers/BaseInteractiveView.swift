//
//  BaseInteractiveView.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import SnapKit
import UIKit

open class BaseInteractiveView: UIView {

    // MARK: - Public Properties

    open var inactiveConstraints: [Constraint] = []

    // MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
        anchorViews()
        configureViews()
        addActions()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        activateConstraints()
    }

    @available(*, unavailable) required public init?(coder aDecoder: NSCoder) {
        fatalError("required init not implemented")
    }

    // to override
    open func addViews() {}
    open func anchorViews() {}
    open func configureViews() {}
    open func addActions() {}

    open func activateConstraints() {
        inactiveConstraints.forEach { $0.isActive = true }
        inactiveConstraints.removeAll()
    }
}
