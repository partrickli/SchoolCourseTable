//
//  CourseTableLayout.swift
//  CourseTableLayoutDemo
//
//  Created by liguiyan on 2017/9/19.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class CourseTableLayout: UICollectionViewLayout {
    
    enum Element: String {
        case TableHeader
        case TableFooter
        case SideBar
        
        var kind: String {
            return "\(rawValue)Kind"
        }
    }
    
    let numberOfColumns = 5
    let headerHeight: CGFloat = 50

    
    var columnWidth: CGFloat {
        return collectionView!.bounds.width / CGFloat(numberOfColumns)
    }
    
    var contentHeight: CGFloat = 0
    
    var cache = [UICollectionViewLayoutAttributes]()
    var supplementaryCaches = Array<[Element: UICollectionViewLayoutAttributes]>()
    
    override var collectionViewContentSize: CGSize {
        
        return CGSize(width: collectionView!.bounds.width, height: contentHeight)
    }
    
    override func prepare() {
        
        
        guard cache.isEmpty == true,
            supplementaryCaches.isEmpty == true,
            let collectionView = collectionView else {
            return
        }
        

        
        var xOffset: CGFloat = 0
        var yOffset = Array<CGFloat>(repeating: 0, count: numberOfColumns)
        
        for section in 0 ..< collectionView.numberOfSections {
            
            var supplementaryCache = [Element: UICollectionViewLayoutAttributes]()
            let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: Element.TableHeader.kind, with: IndexPath(row: 0, section: section))
            headerAttributes.frame = CGRect(x: 0, y: yOffset[0], width: collectionView.bounds.width, height: headerHeight)
            supplementaryCache[Element.TableHeader] = headerAttributes
            supplementaryCaches.append(supplementaryCache)
            for i in 0 ..< yOffset.count {
                yOffset[i] += headerHeight
            }

            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let currentColumn = item % numberOfColumns
                let imageHeight: CGFloat = columnWidth * 0.8
                
                xOffset = CGFloat(currentColumn) * columnWidth
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let cellFrame = CGRect(x: xOffset, y: yOffset[currentColumn], width: columnWidth, height: imageHeight)
                attributes.frame = cellFrame.insetBy(dx: 1, dy: 1)
                cache.append(attributes)
                
                yOffset[currentColumn] += imageHeight
                
                contentHeight = yOffset.reduce(0) { currentMax, offset in
                    return max(currentMax, offset)
                }

                
                print(indexPath)
                print(attributes.frame.origin)
                print()
            }
            
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = cache + supplementaryCaches.map { $0[Element.TableHeader]! }
        let filtered = attributes.filter { $0.frame.intersects(rect) }
        return filtered
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.section * (collectionView?.numberOfSections)! + indexPath.item]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let kind = Element(rawValue: elementKind) {
            return supplementaryCaches[indexPath.section][kind]
        }
        return nil
    }
    
    
}
