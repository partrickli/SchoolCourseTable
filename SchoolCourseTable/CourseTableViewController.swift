//
//  FirstViewController.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/9/25.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class CourseTableViewController: UIViewController {
    
    var stateController: StateController!
    var courseTableCollectionViewDataSource: CourseTableCollectionViewDataSource!
    var courseSelectionCollectionViewDataSource: CourseSelectionCollectionViewDataSource!
    
    @IBOutlet weak var courseTableCollectionView: UICollectionView!
    @IBOutlet weak var courseSelectionCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateController = StateController()
        
        courseTableCollectionViewDataSource = CourseTableCollectionViewDataSource(stateController: stateController)
        courseTableCollectionView.dataSource = courseTableCollectionViewDataSource
        
        courseSelectionCollectionViewDataSource = CourseSelectionCollectionViewDataSource(stateController: stateController)
        courseSelectionCollectionView.dataSource = courseSelectionCollectionViewDataSource
        
        courseTableCollectionView.register(CourseTableHeaderView.self, forSupplementaryViewOfKind: CourseTableLayout.Element.TableHeader.kind, withReuseIdentifier: "CourseTableHeader")
        
        // Course Table Collection View Drop interaction
        courseTableCollectionView.dragInteractionEnabled = true
        courseTableCollectionView.dropDelegate = self

        // Course Selection Collection View Drag Interaction
        
        courseSelectionCollectionView.dragInteractionEnabled = true
        courseSelectionCollectionView.dragDelegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stateController.reloadTeachers()
        courseSelectionCollectionView.reloadData()
    }
    
}

extension CourseTableViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let teacherString = stateController.teachers[indexPath.item].name
        let item = NSItemProvider(object: NSString(string: teacherString))
        let dragItem = UIDragItem(itemProvider: item)
        return [dragItem]
    }
    
}

// drag and drop

//extension CourseTableViewController: UICollectionViewDragDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let item = NSItemProvider(object: NSString(string: courses[indexPath.item].teacher))
//        let dragItem = UIDragItem(itemProvider: item)
//        return [dragItem]
//    }
//
//
//}

extension CourseTableViewController: UICollectionViewDropDelegate {

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {

        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)

        print("drop enabled")
        coordinator.session.loadObjects(ofClass: NSString.self) { nsstrings in
            let string = String(describing: nsstrings.first!)
            let teacher = Teacher(name: string, capableSubjects: [])
            self.stateController.courses[destinationIndexPath.item].teacher = teacher
            collectionView.reloadItems(at: [destinationIndexPath])
        }

    }

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
    }
}

extension CourseTableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}

class CourseTableCollectionViewDataSource: NSObject {
    
    let stateController: StateController
    
    init(stateController: StateController) {
        self.stateController = stateController
    }
    
}

extension CourseTableCollectionViewDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stateController.courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchoolCourseCell", for: indexPath) as! SchoolCourseCell
        cell.courseLabel.text = stateController.courses[indexPath.item].teacher.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: CourseTableLayout.Element.TableHeader.kind, withReuseIdentifier: "CourseTableHeader", for: indexPath)
        return view
    }
    
}

class CourseSelectionCollectionViewDataSource: NSObject {
    
    let stateController: StateController
    
    init(stateController: StateController) {
        self.stateController = stateController
    }
    
}

extension CourseSelectionCollectionViewDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stateController.teachers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseSelectionCell", for: indexPath) as! CourseSelectionCell
        cell.teacherNameLabel.text = stateController.teachers[indexPath.item].name
        return cell
    }
    
    
    
    
}









