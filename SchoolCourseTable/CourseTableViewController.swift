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
        
        stateController.reloadData()
        courseSelectionCollectionView.reloadData()
    }
    
}

extension CourseTableViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let course = stateController.availableCourses[indexPath.item]
        let courseObject = CourseItemProvider(course)
        let item = NSItemProvider(object: courseObject)
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
        
        if coordinator.session.canLoadObjects(ofClass: CourseItemProvider.self) {
            coordinator.session.loadObjects(ofClass: CourseItemProvider.self) { courseItemProviders in
                if let courseItemProvider = courseItemProviders.first as? CourseItemProvider {
                    self.stateController.courses[destinationIndexPath.item] = courseItemProvider.value
                    collectionView.reloadItems(at: [destinationIndexPath])
                }
            }
            
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
        return CGSize(width: 80, height: 80)
    }
}

class CourseTableCollectionViewDataSource: NSObject {
    
    let stateController: StateController
    
    init(stateController: StateController) {
        self.stateController = stateController
    }
    
}

extension CourseTableCollectionViewDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5 // five workday per week
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stateController.totalCoursePerDay
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchoolCourseCell", for: indexPath) as! SchoolCourseCell
        cell.subjectLabel.text = "没课"
        cell.teacherNameLabel.text = "没人"
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
        return stateController.availableCourses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseSelectionCell", for: indexPath) as! CourseSelectionCell
        cell.subjectLabel.text = stateController.availableCourses[indexPath.item].subject.rawValue
        cell.teacherNameLabel.text = stateController.availableCourses[indexPath.item].teacher.name
        return cell
    }
    
}









