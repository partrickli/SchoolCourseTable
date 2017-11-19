//
//  SecondViewController.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/9/25.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class TeachersViewController: UIViewController {
    
    let modelController = ModelController.shared

    @IBOutlet weak var teachersView: UITableView!

    var teachers: [Teacher]!

    
    // unwind segue from teacher editor view controller
    @IBAction func saveTeacher(sender: UIStoryboardSegue) {
        guard let sourceViewController = sender.source as? TeacherEditorController else {
            return
        }
        let newTeacher = sourceViewController.newTeacher
        modelController.teachers.append(newTeacher)
        teachersView.reloadData()
    }
    
    @IBAction func cancelEditor(sender: UIStoryboardSegue) {
        print("editor dismissed")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let teacherDetailController = segue.destination as? TeacherDetailController else {
            return
        }
        guard let cell = sender as? TeacherCell else {
            return
        }
        if let indexPath = teachersView.indexPath(for: cell) {
            let teacher = modelController.teachers[indexPath.row]
            teacherDetailController.teacher = teacher
        }
    }

}

extension TeachersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCell", for: indexPath) as! TeacherCell
        let teacher = modelController.teachers[indexPath.item]
        cell.viewModel = TeacherCell.ViewModel(teacher: teacher)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let removedTeacher = modelController.teachers.remove(at: indexPath.item)
            modelController.schedules = modelController.schedules.filter { schedule in
                schedule.course.teacher != removedTeacher
            }
            tableView.reloadData()
        default:
            return
        }
    }
    
}






























