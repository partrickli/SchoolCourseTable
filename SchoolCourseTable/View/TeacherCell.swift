//
//  TeacherCell.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/9/27.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class TeacherCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capableCoursesLabel: UILabel!
    
    public func config(with teacher: Teacher) {
        nameLabel.text = teacher.name
        capableCoursesLabel.text = teacher.subjectCount.map {
            " \($0.key.rawValue):\($0.value) "
        }.joined()
    }
}
