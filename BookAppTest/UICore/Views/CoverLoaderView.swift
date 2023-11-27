//
//  CoverLoaderView.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 22.11.2023.
//

import SnapKit
import Lottie
import UIKit

final public class CoverLoaderView: BaseInteractiveView  {
    
    // MARK: - Private Properties

    private lazy var loaderAnimation: LottieAnimationView = {
        let loader = LottieAnimationView()
        loader.animation = LottieAnimation.named("loaderDefault")
        loader.backgroundColor = .clear
        loader.contentMode = .scaleAspectFill
        loader.loopMode = .loop
        loader.tintColor = .white
        return loader
    }()
    
    private lazy var blureView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.backgroundColor = .clear
        blurEffectView.contentMode = .scaleToFill
        return blurEffectView
    }()
    
    // MARK: - Lifecycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        makeViewConstraints()
        play()
    }
    
    public override func addViews() {
        addSubviews([blureView, loaderAnimation])
    }
    
    public func play() {
        loaderAnimation.play()
    }
    
    // MARK: - Private Methods
    
    private func makeViewConstraints() {
        loaderAnimation.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.center.equalToSuperview()
        }
        
        blureView.snp.makeConstraints {
            $0.bottom.leading.trailing.top.equalToSuperview()
        }
    }
}
