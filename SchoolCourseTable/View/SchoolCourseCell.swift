//
//  PinterestCell.swift
//  PinterestLayoutDemo
//
//  Created by liguiyan on 2017/9/19.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class SchoolCourseCell: UICollectionViewCell {
    
    struct ViewModel {
        let subject: String
        let teacherName: String
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = ViewModel(subject: "默认", teacherName: "默认")
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 4
        layer.masksToBounds = true
        layer.borderWidth = 1
        
    }
    
    @IBOutlet private weak var subjectLabel: UILabel!
    @IBOutlet private weak var teacherNameLabel: UILabel!
    
    var viewModel: ViewModel {
        didSet {
            subjectLabel.text = viewModel.subject
            teacherNameLabel.text = viewModel.teacherName
        }
    }
}

extension SchoolCourseCell.ViewModel {
    
    init(course: Course) {
        subject = course.subject.rawValue
        teacherName = course.teacher.name
    }
    
    init() {
        subject = ""
        teacherName = ""
    }
}



















