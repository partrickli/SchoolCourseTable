//
//  TeacherEditorController.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/10/12.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

fileprivate struct Section {
    
    enum SectionType: Int {
        case profile
        case course
    }
    
    enum ItemType: Int {
        case teacher
        case courseTable
    }
    
    let sectionType: SectionType
    var items: [ItemType]

}

extension Array where Element == Section {
    var sectionIndices: [Section.SectionType: Int] {
        let keys = self.map { $0.sectionType }
        return Dictionary(uniqueKeysWithValues: zip(keys, indices))
    }
}
class TeacherEditorController: UITableViewController {
    
    private let sections: [Section] = [
        Section(
            sectionType: .profile,
            items: [.teacher]
        ),
        Section(
            sectionType: .course,
            items: Array(repeating: .courseTable, count: Subject.all.count)
        )
    ]
    
    var teacher: Teacher = Teacher() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var newTeacher: Teacher {
        let sectionIndices = sections.sectionIndices
        let nameCell = tableView.cellForRow(at: IndexPath(item: 0, section: sectionIndices[Section.SectionType.profile]!)) as! TeacherNameCell
        let name = nameCell.teacherName ?? ""
        
        let items = Subject.all.indices
        let subjectCells = items.map { item -> SubjectSelectionCell in
            let cell = tableView.cellForRow(at: IndexPath(item: item, section: sectionIndices[Section.SectionType.course]!))
            return cell! as! SubjectSelectionCell
        }
        let subjectCountSequence = subjectCells.map { cell -> (Subject, Int) in
            cell.subjectCount
        }
        let nonZeroSubjects = subjectCountSequence.filter { _, count in
            count != 0
        }
        let count = Dictionary(uniqueKeysWithValues: nonZeroSubjects)
        
        return Teacher(name: name, subjectCount: count)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].items[indexPath.item] {
        case .teacher:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherNameCell", for: indexPath) as! TeacherNameCell
            cell.teacherName = teacher.name
            return cell
        case .courseTable:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectSelectionCell", for: indexPath) as! SubjectSelectionCell
            cell.subjectCount = (Subject.all[indexPath.item], 0)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section].sectionType {
        case .profile:
            return "简介"
        case .course:
            return "课程表"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(teacher.description)
    }
}

// Course subject selection

class TeacherNameCell: UITableViewCell {
    
    struct TeacherProfile {
        let name: String
    }
    
    var teacherName: String? {
        get {
            return teacherNameTextField.text
        }
        set {
            teacherNameTextField.text = newValue
        }
    }
    
    @IBOutlet weak var teacherNameTextField: UITextField!
    
}

extension TeacherNameCell.TeacherProfile {
    
    init(teacher: Teacher) {
        name = teacher.name
    }

}

class SubjectSelectionCell: UITableViewCell {
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var subjectCountLabel: UILabel!
    
    var subjectCount: (key: Subject, value: Int) {
        
        get {
            if let subject = Subject(rawValue: subjectLabel.text!),
                let count = Int(subjectCountLabel.text!) {
                return (subject, count)
            } else {
                return (Subject.blank, 0)
            }
        }
        
        set {
            subjectLabel.text = newValue.key.rawValue
            subjectCountLabel.text = "\(newValue.value)"
        }
    }
    
    @IBAction func changeSubjectCount(_ sender: UIStepper) {
        
        subjectCountLabel.text = String(Int(sender.value))
        
    }
}



























