//
//  SecondViewController.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/9/25.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class TeachersViewController: UIViewController {
    
    private let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private var logsURL: URL {
        return documentDirectoryURL
            .appendingPathComponent("Logs")
            .appendingPathExtension("plist")
    }

    
    @IBOutlet weak var teachersView: UITableView!
    
    var teachers: [Teacher] = [] {
        didSet {
            let encoder = PropertyListEncoder()
            do {
                let data = try encoder.encode(teachers)
                try data.write(to: logsURL)
            } catch  {
                print(error)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let data = try! Data(contentsOf: logsURL)
        let decoder = PropertyListDecoder()
        let decoded = try! decoder.decode([Teacher].self, from: data)
        teachers = decoded
    }
    
    @IBAction func saveTeacher(sender: UIStoryboardSegue) {
        guard let sourceViewController = sender.source as? TeacherEditorController else {
            return
        }
        let newTeacher = sourceViewController.teacher
        teachers.append(newTeacher)
        teachersView.reloadData()
    }

}

extension TeachersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCell", for: indexPath) as! TeacherCell
        cell.nameLabel.text = teachers[indexPath.item].name
        cell.capableCoursesLabel.text = teachers[indexPath.item].capableSubjects.map { $0.rawValue }.joined(separator: " | ")
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
































