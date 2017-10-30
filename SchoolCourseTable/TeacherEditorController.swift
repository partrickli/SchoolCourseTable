//
//  TeacherEditorController.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/10/12.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class TeacherEditorController: UITableViewController {
    
    var teacher: Teacher!
    {
        get {
            guard let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TeacherNameCell,
                let name = nameCell.teacherNameTextField.text else {
                return nil
            }
            let numberOfRowsInSubjectSection = tableView.numberOfRows(inSection: 1)
            let indexPathsInSubjectSection = (0..<numberOfRowsInSubjectSection).map { row in
                return IndexPath(row: row, section: 1)
            }
            let subjectCountPair = indexPathsInSubjectSection.flatMap { indexPath -> (Subject, Int)? in
                let cell = tableView.cellForRow(at: indexPath) as! SubjectSelectionCell
                if let subject = Subject(rawValue: cell.subjectLabel.text!),
                    let count = Int(cell.subjectCountLabel.text!), count != 0 {
                    return (subject, count)
                } else {
                    return nil
                }
            }
            let subjectCount = Dictionary(uniqueKeysWithValues: subjectCountPair)
            return Teacher(name: name, subjectCount: subjectCount)
        }
        
        set {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        teacher = Teacher(name: "partrick", subjectCount: [.art: 1, .english: 2])

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return Subject.all.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherNameCell") as! TeacherNameCell
            cell.teacherNameTextField.text = "李老师"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectSelectionCell", for: indexPath) as! SubjectSelectionCell
            let randomInt = Int(arc4random()) % Subject.all.count
            let subjectCount = [Subject.all[indexPath.row]: randomInt]
            cell.subjectCount = subjectCount
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "名字"
        case 1:
            return "课程"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(teacher.description)
    }
}

// Course subject selection

class TeacherNameCell: UITableViewCell {
    
    @IBOutlet weak var teacherNameTextField: UITextField!
    
}

class SubjectSelectionCell: UITableViewCell {
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var subjectCountLabel: UILabel!
    
    var subjectCount: [Subject: Int] {
        
        get {
            if let subjectString = subjectLabel.text,
                let subject = Subject(rawValue: subjectString),
                let countString = subjectCountLabel.text,
                let count = Int(countString) {
                return [subject: count]
            } else {
                return [Subject.blank: 0]
            }
        }
        
        set {
            subjectLabel.text = newValue.keys.first?.rawValue
            subjectCountLabel.text = String(describing: newValue.values.first ?? 0)
        }
    }
    
    @IBAction func changeSubjectCount(_ sender: UIStepper) {
        
        print("stepper button pressed")
        subjectCountLabel.text = String(Int(sender.value))
        
    }
}



























