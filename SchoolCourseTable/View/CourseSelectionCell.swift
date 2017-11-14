//
//  CourseSelectionCell.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/10/18.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class CourseSelectionCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderWidth = 1
    }
    
    struct CourseSelectionData {
        let subject: String
        let teacherName: String
    }
    
    var courseSelectionData: CourseSelectionData? {
        didSet {
            subjectLabel.text = courseSelectionData?.subject
            teacherNameLabel.text = courseSelectionData?.teacherName
        }
    }
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var teacherNameLabel: UILabel!
}

extension CourseSelectionCell.CourseSelectionData {
    init(course: Course) {
        subject = course.subject.rawValue
        teacherName = course.teacher.name
    }
}
