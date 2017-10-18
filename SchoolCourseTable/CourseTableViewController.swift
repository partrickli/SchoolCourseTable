//
//  FirstViewController.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/9/25.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class CourseTableViewController: UIViewController {
    
    @IBOutlet weak var courseTableCollectionView: UICollectionView!
    
    var courses = Array(repeating: Course(), count: 30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courseTableCollectionView.register(CourseTableHeaderView.self, forSupplementaryViewOfKind: CourseTableLayout.Element.TableHeader.kind, withReuseIdentifier: "CourseTableHeader")
        
        // drag interaction
//        courseTableCollectionView.dragInteractionEnabled = true
//        courseTableCollectionView.dragDelegate = self
        
//        courseTableCollectionView.dropDelegate = self

    }
    
}

extension CourseTableViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchoolCourseCell", for: indexPath) as! SchoolCourseCell
        cell.courseLabel.text = courses[indexPath.item].teacher.name
        cell.backgroundColor = .lightGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: CourseTableLayout.Element.TableHeader.kind, withReuseIdentifier: "CourseTableHeader", for: indexPath)
        return view
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

//extension CourseTableViewController: UICollectionViewDropDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//
//        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
//
//        print("drop enabled")
//        coordinator.session.loadObjects(ofClass: NSString.self) { nsstrings in
//            let string = String(describing: nsstrings.first!)
//            self.courses[destinationIndexPath.item].teacher.name = string
//            collectionView.reloadItems(at: [destinationIndexPath])
//        }
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
//        return true
//    }
//
//    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
//        return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
//    }
//}














