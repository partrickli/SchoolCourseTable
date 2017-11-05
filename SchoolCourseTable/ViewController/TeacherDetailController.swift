//
//  TeacherDetailController.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/10/31.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class TeacherDetailController: UITableViewController {
    
    var teacher: Teacher! 
    var arrangedSchedules: [Schedule] = []
    let stateController = StateController()

    override func viewDidLoad() {
        super.viewDidLoad()

        arrangedSchedules = stateController.schedules.filter {
            $0.course.teacher == teacher
        }
        
        title = teacher.name
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrangedSchedules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherDetailArrangedSchedule", for: indexPath) as! TeacherDetailScheduleCell
        cell.config(with: arrangedSchedules[indexPath.row], of: indexPath.row)
        return cell
    }
    
}


class TeacherDetailScheduleCell: UITableViewCell {
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    func config(with schedule: Schedule, of row: Int) {
        subjectLabel.text = "\(row + 1) \(schedule.course.subject.rawValue)"
        timeLabel.text = schedule.time.description
        gradeLabel.text = schedule.gradeClass.description
    }
}





















