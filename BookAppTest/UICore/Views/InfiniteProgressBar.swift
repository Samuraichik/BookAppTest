//
//  InfiniteProgressBar.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 21.11.2023.
//

import Foundation
import UIKit
import SnapKit
import UIKit

final class InfiniteProgressBar: BaseInteractiveView {
    //MARK: Public Properties
    
    var primaryColor: UIColor = .blue {
        didSet {
            progressBarIndicator.backgroundColor = primaryColor
        }
    }

    var secondaryColor: UIColor = .lightGray {
        didSet {
            backgroundColor = secondaryColor
        }
    }

    var indeterminateAnimationDuration: TimeInterval = 1.0
    
    //MARK: Private Properties
    
    private lazy var progressBarIndicator: UIView = {
        $0.backgroundColor = primaryColor
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return $0
    }(UIView(frame: zeroFrame))

    private var zeroFrame: CGRect {
        .init(
            origin: .zero,
            size: .init(
                width: 0,
                height: bounds.size.height
            )
        )
    }
    
    //MARK: Interface Methods

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateForForegroundState()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateForForegroundState()
    }

    //MARK: Setup

    override func configureViews() {
        super.configureViews()
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = secondaryColor
    }
    
    override func addViews() {
        self.addSubview(progressBarIndicator)
    }
    
    //MARK: Public Methods

    func restartAnimation() {
        transition()
    }
}

private extension InfiniteProgressBar {
    // MARK: Private Methods
    func transition(
        delay: TimeInterval = 0,
        animateDeterminate: Bool = true
    ) {

        guard window != nil else {
            return
        }
        startAnimation(delay: delay)
    }
    
    func updateForBackgroundState() {
        stopIndeterminateAnimation()
    }
    
    @MainActor
    func updateForForegroundState() {
        Task {
            self.transition()
        }
    }
    
    func stopIndeterminateAnimation() {
        moveProgressBarIndicatorToStart()
    }
    
    func moveProgressBarIndicatorToStart() {
        progressBarIndicator.layer.removeAllAnimations()
        progressBarIndicator.frame = zeroFrame
        progressBarIndicator.layoutIfNeeded()
    }
    
    func startAnimation(delay: TimeInterval = 0) {
        moveProgressBarIndicatorToStart()
        
        UIView.animateKeyframes(
            withDuration: indeterminateAnimationDuration,
            delay: delay,
            options: [.repeat],
            animations: { [weak self] in
                guard let self = self else { return }
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: indeterminateAnimationDuration/2,
                    animations: { [weak self] in
                        guard let self = self else { return }
                        
                        self.progressBarIndicator.frame = .init(
                            x: 0,
                            y: 0,
                            width: bounds.width * 0.7,
                            height: bounds.size.height
                        )
                    })
                
                UIView.addKeyframe(
                    withRelativeStartTime: self.indeterminateAnimationDuration/2,
                    relativeDuration: self.indeterminateAnimationDuration/2,
                    animations: { [weak self] in
                        guard let self = self else { return }
                        
                        progressBarIndicator.frame = .init(
                            x: bounds.width,
                            y: 0,
                            width: bounds.width * 0.3,
                            height: bounds.size.height
                        )
                    })
            })
    }
}
