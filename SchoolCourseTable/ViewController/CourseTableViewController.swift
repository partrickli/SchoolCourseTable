//
//  FirstViewController.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/9/25.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class CourseTableViewController: UIViewController {
    
    var courseTableDataSource: CourseTableDataSource!
    var courseSelectionDataSource: CourseSelectionDataSource!
    
    @IBOutlet weak var courseTableCollectionView: UICollectionView!
    @IBOutlet weak var courseSelectionCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        courseTableDataSource = CourseTableDataSource()
        courseTableCollectionView.dataSource = courseTableDataSource
        
        courseSelectionDataSource = CourseSelectionDataSource()
        courseSelectionCollectionView.dataSource = courseSelectionDataSource
        
        courseTableCollectionView.register(CourseTableHeaderView.self, forSupplementaryViewOfKind: CourseTableLayout.Element.TableHeader.kind, withReuseIdentifier: "CourseTableHeader")
        
        // Course Table Collection View Drop interaction and drag interaction
        courseTableCollectionView.dragInteractionEnabled = true
//        courseTableCollectionView.dragDelegate = self
        courseTableCollectionView.dropDelegate = self

        // Course Selection Collection View Drag Interaction
        
        courseSelectionCollectionView.dragInteractionEnabled = true
        courseSelectionCollectionView.dragDelegate = courseSelectionDataSource
        
        // customize appearence
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        courseSelectionDataSource.reloadData()
        courseSelectionCollectionView.reloadData()
    }
    
    
}


extension CourseSelectionDataSource: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let course = courses[indexPath.item]
        let courseObject = CourseItemProvider(course)
        let item = NSItemProvider(object: courseObject)
        let dragItem = UIDragItem(itemProvider: item)
        dragItem.localObject = indexPath
        return [dragItem]
    }
}


extension CourseTableViewController: UICollectionViewDropDelegate {

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        if let dragItem = coordinator.session.items.first {
            if let sourceIndexPath = dragItem.localObject as? IndexPath {
//                self.courseTableDataSource.courses[sourceIndexPath.section][sourceIndexPath.row] = Course()
                collectionView.reloadItems(at: [sourceIndexPath])
            }
        }
        
        
        if coordinator.session.canLoadObjects(ofClass: CourseItemProvider.self) {
            coordinator.session.loadObjects(ofClass: CourseItemProvider.self) { courseItemProviders in
                if let courseItemProvider = courseItemProviders.first as? CourseItemProvider {
//                    self.courseTableDataSource.courses[destinationIndexPath.section][destinationIndexPath.row] = courseItemProvider.value
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


class CourseSelectionDataSource: NSObject {
    
    var courses: [Course] = []
    
    func reloadData() {
        let storage = StorageController()
        courses = storage.availableCourses
    }
}

extension CourseSelectionDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseSelectionCell", for: indexPath) as! CourseSelectionCell
        let courseData = CourseSelectionCell.CourseSelectionData(course: courses[indexPath.item])
        cell.courseSelectionData = courseData
        return cell
    }
    
}








