//
//  PinterestCell.swift
//  PinterestLayoutDemo
//
//  Created by liguiyan on 2017/9/19.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class SchoolCourseCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .white
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderWidth = 1
    }
    
    @IBOutlet weak var courseLabel: UILabel!

}
