//
//  SecondViewController.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/9/25.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class TeachersViewController: UIViewController {
    
    @IBOutlet weak var teachersView: UITableView!
    let storage = StorageController()

    var teachers: [Teacher] = [] {
        didSet {
            storage.teachersResource.save(value: teachers)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teachers = storage.teachersResource.reload() ?? []
    }

    
    // unwind segue from teacher editor view controller
    @IBAction func saveTeacher(sender: UIStoryboardSegue) {
        guard let sourceViewController = sender.source as? TeacherEditorController else {
            return
        }
        let newTeacher = sourceViewController.newTeacher
        teachers.append(newTeacher)
        teachersView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let teacherDetailController = segue.destination as? TeacherDetailController else {
            return
        }
        guard let cell = sender as? TeacherCell else {
            return
        }
        if let indexPath = teachersView.indexPath(for: cell) {
            let teacher = teachers[indexPath.row]
            teacherDetailController.teacher = teacher
        }
    }

}

extension TeachersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCell", for: indexPath) as! TeacherCell
        cell.config(with: teachers[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            teachers.remove(at: indexPath.item)
            tableView.reloadData()
        default:
            return
        }
    }
    
}






























