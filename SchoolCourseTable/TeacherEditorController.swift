//
//  TeacherEditorController.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/10/12.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class TeacherEditorController: UITableViewController {
    
    @IBOutlet weak var teacherNameTextField: UITextField!
    
    var teacher: Teacher {
        
        get {
            let name = teacherNameTextField.text ?? "老师名字没填"
            let subjects = subjectSelectionView.indexPathsForSelectedItems!.map { indexPath in
                return Subject.all[indexPath.item]
            }
            return Teacher(name: name, capableSubjects: subjects)
        }
        
        set {
            teacherNameTextField.text = newValue.name
            let capableSubjects = newValue.capableSubjects
            let items = capableSubjects.flatMap { subject in
                return Subject.indexDict[subject]
            }
            for item in items {
                if let cell = subjectSelectionView.cellForItem(at: IndexPath(item: item, section: 0)) {
                    cell.backgroundColor = .orange
                }
            }
        }
    }
    
    @IBOutlet weak var subjectSelectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        subjectSelectionView.allowsMultipleSelection = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        teacher = Teacher(name: "partrick", capableSubjects: [.art, .english])

    }
}

// Course subject selection

class CourseSubjectCell: UICollectionViewCell {
    @IBOutlet weak var subjectLabel: UILabel!
}

extension TeacherEditorController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Subject.all.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseSubjectCell", for: indexPath) as! CourseSubjectCell
        cell.subjectLabel.text = Subject.all[indexPath.item].rawValue
        return cell
    }
    
}

extension TeacherEditorController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CourseSubjectCell
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.layer.shadowOpacity = 0.8
        print(collectionView.indexPathsForSelectedItems!)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! CourseSubjectCell
//
//        print(collectionView.indexPathsForSelectedItems!)
//    }
}

























