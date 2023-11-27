//
//  DetailsInfoSubview.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 24.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class DetailsInfoStackSubview: BaseInteractiveView {
    var topLabelText: String {
        get { topLabel.text ?? "" }
        set { topLabel.text = newValue }
    }
    
    var bottomLabelText: String {
        get { bottomLabel.text ?? "" }
        set { bottomLabel.text = newValue }
    }
    
    // MARK: - Private Properties
    
    private lazy var topLabel: UILabel = {
        $0.apply(
            Rswift.font.nunitoSansBold(size: 18),
            color: .black,
            numberOfLines: 0, 
            text: ""
        )
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return $0
    }(UILabel())
    
    private lazy var bottomLabel: UILabel = {
        $0.apply(
            Rswift.font.nunitoSansSemiBold(size: 12),
            color: Rswift.colors.otherDisabledColor(),
            numberOfLines: 0,
            text: ""
        )
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return $0
    }(UILabel())
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeViewConstraints()
    }
    
    override func addViews() {
        addSubviews([topLabel, bottomLabel])
    }
    
    // MARK: - Public Methods
    
    func setUpView(topText: String, bottomText: String) {
        bottomLabel.text = bottomText
    }
    
    // MARK: - Private Methods
    
    private func makeViewConstraints() {
        topLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        bottomLabel.snp.makeConstraints {
            $0.top.equalTo(topLabel.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}
