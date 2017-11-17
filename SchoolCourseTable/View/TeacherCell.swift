//
//  TeacherCell.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/9/27.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class TeacherCell: UITableViewCell {
    
    struct ViewModel {
        let teacherName: String
        let capableCourses: String
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capableCoursesLabel: UILabel!
    
    var viewModel: ViewModel = ViewModel() {
        didSet {
            nameLabel.text = viewModel.teacherName
            capableCoursesLabel.text = viewModel.capableCourses
        }
    }
}

extension TeacherCell.ViewModel {
    
    init(teacher: Teacher) {
        self.teacherName = teacher.name
        self.capableCourses = teacher.subjectCount.map {
            " \($0.key.rawValue):\($0.value) "
        }.joined()
    }
    
    init() {
        self.teacherName = ""
        self.capableCourses = ""
    }
    
}
