//
//  TeacherDetailScheduleCell.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/11/6.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class TeacherDetailScheduleCell: UITableViewCell {
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    public func config(with schedule: Schedule, of row: Int) {
        subjectLabel.text = "\(row + 1) \(schedule.course.subject.rawValue)"
        timeLabel.text = schedule.time.description
        gradeLabel.text = schedule.gradeClass.description
    }
}
