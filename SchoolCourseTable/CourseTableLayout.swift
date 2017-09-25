//
//  CourseTableLayout.swift
//  CourseTableLayoutDemo
//
//  Created by liguiyan on 2017/9/19.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

protocol CourseTableLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
}

class CourseTableLayout: UICollectionViewLayout {
    
    weak var delegate: CourseTableLayoutDelegate!

    let numberOfColumns = 2
    
    var columnWidth: CGFloat {
        return collectionView!.bounds.width / CGFloat(numberOfColumns)
    }
    
    var contentHeight: CGFloat = 0
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        
        return CGSize(width: collectionView!.bounds.width, height: contentHeight)
    }
    
    override func prepare() {
        
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        
        var xOffset: CGFloat = 0
        var yOffset = Array<CGFloat>(repeating: 0, count: numberOfColumns)
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            let currentColumn = item % numberOfColumns
            let imageHeight: CGFloat = delegate.collectionView(collectionView, heightForItemAt: indexPath, with: columnWidth)
            
            xOffset = CGFloat(currentColumn) * columnWidth
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: xOffset, y: yOffset[currentColumn], width: columnWidth, height: imageHeight)
            cache.append(attributes)
            
            yOffset[currentColumn] += imageHeight
            
            contentHeight = yOffset.reduce(0) { currentMax, offset in
                return max(currentMax, offset)
            }
            
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let filtered = cache.filter { $0.frame.intersects(rect) }
        return filtered
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
}
