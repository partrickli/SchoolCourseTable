//
//  CourseTableLayout.swift
//  CourseTableLayoutDemo
//
//  Created by liguiyan on 2017/9/19.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class CourseTableLayout: UICollectionViewLayout {
    
    let numberOfColumns = 5
    
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
            let imageHeight: CGFloat = columnWidth * 0.618
            
            xOffset = CGFloat(currentColumn) * columnWidth
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let cellFrame = CGRect(x: xOffset, y: yOffset[currentColumn], width: columnWidth, height: imageHeight)
            attributes.frame = cellFrame.insetBy(dx: 1, dy: 1)
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
