//
//  TeacherPersonalCourseTableDataSource.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/11/6.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class TeacherPersonalCourseTableDataSource: NSObject {
    
    private var courses: Matrix<Course>
    
    init(schedules: [Schedule]) {
        
        let blankCourse = Course()
        var courses = Matrix(repeating: blankCourse, rows: 7, columns: 5)
        for schedule in schedules {
            let row = schedule.time.order - 1
            let column = schedule.time.day - 1
            courses[row, column] = schedule.course
        }
        self.courses = courses
    }
}

extension TeacherPersonalCourseTableDataSource: UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchoolCourseCell", for: indexPath) as! SchoolCourseCell
        cell.subjectLabel.text = courses[indexPath.item].subject.rawValue
        return cell
    }
    
}













