//
//  UICustomCollectionViewLayout.swift
//  Rococo
//
//  Created by oleksiy humenyuk on 28.08.2023.
//

import UIKit

final class UICustomCollectionViewLayout: UICollectionViewLayout {
    
    // MARK: - Private properties
    
    private var cellSpacing: CGFloat
    private var attributesDict = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    private var sectionWidths: [CGFloat]
    private var contentSize: CGSize = .zero
    private var sectionInset: CGFloat

    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }

    init(
        sectionWidthFractions: [CGFloat],
        cellSpacing: CGFloat = 0,
        sectionInset: CGFloat = 0
    ) {
        self.cellSpacing = cellSpacing
        self.sectionInset = sectionInset
        let collectionViewWidth = UIScreen.main.bounds.width
        self.sectionWidths = sectionWidthFractions.map {
            collectionViewWidth * $0
        }
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override functions
    
    override func prepare() {
        if let cv = collectionView {
            let collectionViewHeight = cv.frame.height
            
            let numberOfSections = cv.numberOfSections
            self.contentSize = cv.frame.size
            
            let totalSectionWidths = sectionWidths.reduce(0, +)
            self.contentSize.width = totalSectionWidths + CGFloat(numberOfSections - 1) * cellSpacing
            
            var currentXPos: CGFloat = 0
            
            for (section, sectionWidth) in sectionWidths.enumerated() {
                let numberOfItemsInSection = cv.numberOfItems(inSection: section)
                let itemHeight = (collectionViewHeight - (numberOfItemsInSection == 2 ? cellSpacing : 0) ) / CGFloat(numberOfItemsInSection)
                
                for item in 0..<numberOfItemsInSection {
                    let indexPath = IndexPath(item: item, section: section)
                    let itemYPos = itemHeight * CGFloat(item) + CGFloat(item) * cellSpacing
                    
                    let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    
                    attr.frame = CGRect(
                        x: currentXPos,
                        y: itemYPos,
                        width: sectionWidth,
                        height: itemHeight
                    )
                    
                    attributesDict[indexPath] = attr
                }
                
                currentXPos += sectionWidth + cellSpacing
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        for cellAttributes in attributesDict.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        
        return attributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesDict[indexPath]!
    }

}
