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
        
        // Course Table Collection View Drop interaction and drag interaction
        courseTableCollectionView.dragInteractionEnabled = true
        courseTableCollectionView.dragDelegate = self
        courseTableCollectionView.dropDelegate = self

        // Course Selection Collection View Drag Interaction
        
        courseSelectionCollectionView.dragInteractionEnabled = true
        courseSelectionCollectionView.dragDelegate = self
        
        // customize appearence
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stateController.reloadData()
        courseSelectionCollectionView.reloadData()
    }
    
    
}

extension CourseTableViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        var course: Course?
        
        if collectionView == courseSelectionCollectionView {
            course = stateController.availableCourses[indexPath.item]
        } else if collectionView == courseTableCollectionView {
            course = courseTableCollectionViewDataSource.courses[indexPath.section][indexPath.row]
        }
        
        let courseObject = CourseItemProvider(course ?? Course())
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
                self.courseTableCollectionViewDataSource.courses[sourceIndexPath.section][sourceIndexPath.row] = Course()
                collectionView.reloadItems(at: [sourceIndexPath])
            }
        }
        
        
        if coordinator.session.canLoadObjects(ofClass: CourseItemProvider.self) {
            coordinator.session.loadObjects(ofClass: CourseItemProvider.self) { courseItemProviders in
                if let courseItemProvider = courseItemProviders.first as? CourseItemProvider {
                    self.courseTableCollectionViewDataSource.courses[destinationIndexPath.section][destinationIndexPath.row] = courseItemProvider.value
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
    
    private let stateController: StateController
    
    let coursePerDay = 7
    let classCount = 5
    
    var courses: [Array<Course>] {
        didSet {
            stateController.schedules = format(from: courses)
        }
    }
    
    
    func format(from courses: [Array<Course>]) -> [Schedule] {
        let schedules = courses.enumerated().flatMap { (section, coursesPerSection) -> Array<Schedule> in
            let day = section + 1
            let schedulesPerSection = coursesPerSection.enumerated().map { (row, course) -> Schedule in
                let time = ScheduleTime(day: day, order: row / classCount + 1)
                let gradeClass = GradeClass(grade: 1, classInGrade: row % classCount + 1)
                return Schedule(course: course, time: time, gradeClass: gradeClass)
            }
            return schedulesPerSection
        }
        return schedules
    }
    
    init(stateController: StateController) {
        self.stateController = stateController
        

        let coursePerSection = coursePerDay * classCount
        self.courses = (0..<5).map { _ in
            (0..<coursePerSection).map { _ in
                return Course()
            }
        }
        
        for schedule in stateController.schedules {
            let section = schedule.time.day - 1
            let order = schedule.time.order
            let classInGrade = schedule.gradeClass.classInGrade
            let row = (order - 1) * classCount + (classInGrade - 1)
            courses[section][row] = schedule.course
        }
    }
    
    func convert(indexPath: IndexPath) -> (Int, Int) {
        let order = indexPath.item / stateController.classCountPerGrade
        let classIndex = indexPath.item % stateController.classCountPerGrade
        return (order, classIndex)
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
        let course = courses[indexPath.section][indexPath.row]
        cell.subjectLabel.text = course.subject.rawValue
        cell.teacherNameLabel.text = course.teacher.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: CourseTableLayout.Element.TableHeader.kind, withReuseIdentifier: "CourseTableHeader", for: indexPath) as! CourseTableHeaderView
        view.label.text = "星期\(indexPath.section + 1)"
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









