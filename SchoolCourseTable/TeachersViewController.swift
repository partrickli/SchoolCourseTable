//
//  SecondViewController.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/9/25.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class TeachersViewController: UIViewController {
    
    var stateController: StateController!
    
    @IBOutlet weak var teachersView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stateController = StateController()
    }
    
    @IBAction func saveTeacher(sender: UIStoryboardSegue) {
        guard let sourceViewController = sender.source as? TeacherEditorController else {
            return
        }
        let newTeacher = sourceViewController.teacher
        stateController.teachers.append(newTeacher)
        teachersView.reloadData()
    }

}

extension TeachersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateController.teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCell", for: indexPath) as! TeacherCell
        cell.nameLabel.text = stateController.teachers[indexPath.item].name
        cell.capableCoursesLabel.text = stateController.teachers[indexPath.item].capableSubjects.map { $0.rawValue }.joined(separator: " | ")
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            stateController.teachers.remove(at: indexPath.item)
            tableView.reloadData()
        default:
            return
        }
    }
    
}
































