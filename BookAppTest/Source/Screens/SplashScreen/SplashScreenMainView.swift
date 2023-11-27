//
//  SplashScreenMainView.swift
//  Rococo
//
//  Created by oleksiy humenyuk on 18.08.2023.
//

import Foundation
import UIKit
import SnapKit

final class SplashScreenMainView: BaseInteractiveView {
    
    // MARK: - Public Properties
    
    private lazy var mainTitle: UILabel = {
        $0.apply(
            Rswift.font.georgiaBoldItalic(size: 52),
            color: Rswift.colors.otherButtonColor(),
            numberOfLines: 1,
            text: Rswift.strings.splashTitle()
        )
        return $0
    }(UILabel())
    
    private lazy var subtitle: UILabel = {
        $0.apply(
            Rswift.font.nunitoSansBold(size: 24),
            color: Rswift.colors.white80(),
            numberOfLines: 1,
            text: Rswift.strings.splashSubtitle()
        )
        return $0
    }(UILabel())
    
    private lazy var backgroundImageView: UIImageView = {
        $0.image = Rswift.images.splashBackground()
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    private lazy var backgroundHeartsImageView: UIImageView = {
        $0.image = Rswift.images.heartBackground()
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    lazy var progressBar: InfiniteProgressBar = {
        $0.primaryColor = .white
        $0.secondaryColor = Rswift.colors.progressBarBackgroundColor()!
        $0.layer.cornerRadius = 3
        return $0
    }(InfiniteProgressBar())
    
    // MARK: - Lifecycle
    
    override func addViews() {
        super.addViews()
        addSubviews([
            backgroundImageView,
            backgroundHeartsImageView,
            progressBar,
            subtitle,
            mainTitle
        ])
    }
    
    override func anchorViews() {
        super.anchorViews()
        inactiveConstraints.append(contentsOf: prepareBackgroundImageViewConstraints())
        inactiveConstraints.append(contentsOf: prepareBackgroundHeartsImageViewConstraints())
        inactiveConstraints.append(contentsOf: prepareProgressBarConstraints())
        inactiveConstraints.append(contentsOf: prepareTitleConstraints())
        inactiveConstraints.append(contentsOf: prepareSubtitleConstraints())
    }
}

private extension SplashScreenMainView {
    // MARK: - Private Methods
    
    
    func prepareTitleConstraints() -> [Constraint] {
        mainTitle.snp.prepareConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(subtitle.snp.top).offset(-12)
        }
    }
    
    func prepareSubtitleConstraints() -> [Constraint] {
        subtitle.snp.prepareConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(progressBar.snp.top).offset(-45)
        }
    }
    
    func prepareBackgroundImageViewConstraints() -> [Constraint] {
        backgroundImageView.snp.prepareConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func prepareBackgroundHeartsImageViewConstraints() -> [Constraint] {
        backgroundHeartsImageView.snp.prepareConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(37)
            $0.bottom.equalToSuperview().offset(-37)
        }
    }
    
    func prepareProgressBarConstraints() -> [Constraint] {
        progressBar.snp.prepareConstraints {
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(6)
        }
    }
}
