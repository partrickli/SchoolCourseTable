//
//  TeacherDetailController.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/10/31.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit



class TeacherDetailController: UIViewController {
    
    var teacher: Teacher!
    var courseTableOfTeacher: CourseTableOfTeacher!
    
    @IBOutlet weak var courseTableCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.courseTableOfTeacher = CourseTableOfTeacher(teacher)
        courseTableCollectionView.dataSource = courseTableOfTeacher
        title = teacher.name
        
    }

    
    
    
}

class TeacherDetailTableViewDataSource: NSObject {
    let teacher: Teacher
    
    init(_ teacher: Teacher) {
        self.teacher = teacher
    }
}

extension TeacherDetailTableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teacher.subjectCount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherDetailArrangedSchedule", for: indexPath) as! TeacherDetailScheduleCell
        return cell
        
    }

}
























