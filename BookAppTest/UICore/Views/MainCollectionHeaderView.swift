//
//  MainCollectionHeaderView.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 22.11.2023.
//

import Foundation
import UIKit
import SnapKit

class HeaderView: UICollectionReusableView, Reusable {
    private lazy var title: UILabel = {
     
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.adjustsFontForContentSizeCategory = true
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        makeHeaderConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setTitle(titleText: String) {
        title.apply(
            Rswift.font.nunitoSansBold(size: 20),
            color: .white,
            text: titleText
        )
    }
    
    func makeHeaderConstraints() {
        addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
