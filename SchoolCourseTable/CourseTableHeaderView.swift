//
//  CourseTableHeaderView.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/9/28.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class CourseTableHeaderView: UICollectionReusableView {
    
    let label: UILabel = {
        let l = UILabel()
        l.text = "年级"
        l.backgroundColor = .lightGray
        l.textColor = .white
        l.font = UIFont.preferredFont(forTextStyle: .headline)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
