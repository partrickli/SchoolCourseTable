//
//  CourseTableOfTeacher.swift
//  SchoolCourseTable
//
//  Created by 李桂炎 on 2017/11/19.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class CourseTableOfTeacher: NSObject {
    
    private let courseCountPerDay = 7
    private let workDayCountPerWeek = 5
    private var courseTable: Matrix<Course>
    
    init(_ teacher: Teacher) {
        courseTable = Matrix(repeating: Course(), rows: courseCountPerDay, columns: workDayCountPerWeek)
        
        let modelController = ModelController.shared
        let schedules = modelController.schedules.filter { schedule in
            print(teacher)
            print(schedule.course.teacher)
            return schedule.course.teacher.name == teacher.name
        }
        
        for schedule in schedules {
            let row = schedule.time.order - 1
            let column = schedule.time.day - 1
            courseTable[row, column] = schedule.course
        }
    }
}

extension CourseTableOfTeacher: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courseTable.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchoolCourseCell", for: indexPath) as! SchoolCourseCell
        let cellData = SchoolCourseCell.ViewModel(course: courseTable[indexPath.item])
        cell.viewModel = cellData
        return cell
    }
    
}
