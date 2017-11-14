//
//  PinterestCell.swift
//  PinterestLayoutDemo
//
//  Created by liguiyan on 2017/9/19.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class SchoolCourseCell: UICollectionViewCell {
    
    struct CourseData {
        let subject: String
        let teacherName: String
    }
    
    required init?(coder aDecoder: NSCoder) {
        courseData = CourseData(subject: "默认", teacherName: "默认")
        super.init(coder: aDecoder)
        backgroundColor = .white
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderWidth = 1
        
    }
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var teacherNameLabel: UILabel!
    
    var courseData: CourseData {
        didSet {
            subjectLabel.text = courseData.subject
            teacherNameLabel.text = courseData.teacherName
        }
    }
}

extension SchoolCourseCell.CourseData {
    init(course: Course) {
        subject = course.subject.rawValue
        teacherName = course.teacher.name
    }
}



















