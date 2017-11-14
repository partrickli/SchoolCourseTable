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
    var schedules = [Schedule]()
    var courseTableDataSource: TeacherPersonalCourseTableDataSource!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        arrangedSchedules = schedules.filter {
            $0.course.teacher == teacher
        }
        
        title = teacher.name
        courseTableDataSource = TeacherPersonalCourseTableDataSource(schedules: arrangedSchedules)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    // title for header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sectionCase = Section(rawValue: section) else {
            return nil
        }
        
        switch sectionCase {
        case .courseTable:
            return "老师课程表"
        case .scheduleList:
            return "课程清单"
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sectionCase = Section(rawValue: section) else {
            return 0
        }
        switch sectionCase {
        case .courseTable:
            return 1
        case .scheduleList:
            return arrangedSchedules.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let sectionCase = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        switch sectionCase {
        case .courseTable:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherDetailCourseTable", for: indexPath) as! TeacherCourseTableCell
            cell.courseTableCollectionView.dataSource = courseTableDataSource
            return cell
        case .scheduleList:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherDetailArrangedSchedule", for: indexPath) as! TeacherDetailScheduleCell
            cell.config(with: arrangedSchedules[indexPath.row], of: indexPath.row)
            return cell
        }
        
    }
    
}





fileprivate enum Section: Int {
    case courseTable = 0
    case scheduleList = 1
}





















