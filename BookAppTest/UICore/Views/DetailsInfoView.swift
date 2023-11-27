//
//  DetailsInfoView.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 24.11.2023.
//

import SnapKit
import UIKit

final class DetailsInfoView: BaseInteractiveView {
    // MARK: - Private Properties
    
    private lazy var readersView: DetailsInfoStackSubview = {
        $0.bottomLabelText = Rswift.strings.detailsReadersText()
        return $0
    }(DetailsInfoStackSubview())
    
    private lazy var likesView: DetailsInfoStackSubview = {
        $0.bottomLabelText = Rswift.strings.detailsLikesText()
        return $0
    }(DetailsInfoStackSubview())
    
    private lazy var quotesView: DetailsInfoStackSubview = {
        $0.bottomLabelText = Rswift.strings.detailsQuotesText()
        return $0
    }(DetailsInfoStackSubview())
    
    private lazy var genreView: DetailsInfoStackSubview = {
        $0.bottomLabelText = Rswift.strings.detailsGenreText()
        return $0
    }(DetailsInfoStackSubview())
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.spacing = 40
        stack.alignment = .center
        stack.axis = .horizontal
        return stack
    }()
    
    private lazy var separatorView: UIView = {
        $0.backgroundColor = Rswift.colors.otherDisabledColor()
        return $0
    }(UIView())
    
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        makeViewConstraints()
    }
    
    override func addViews() {
        addSubviews([mainStackView, separatorView])
        
        mainStackView.addArrangedSubviews([
            readersView,
            likesView,
            quotesView,
            genreView
        ])
    }
    
    // MARK: - Public Methods
    
    func setUpView(data: Book) {
        readersView.topLabelText = data.views
        likesView.topLabelText = data.likes
        quotesView.topLabelText = data.quotes
        genreView.topLabelText = data.genre
        
    }
    
    // MARK: - Private Methods
    
    private func makeViewConstraints() {
        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(mainStackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
