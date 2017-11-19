//
//  CourseTableCollectionViewDataSource.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/11/6.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class CourseTableDataSource: NSObject {
    
    private let classCountPerGrade = 5
    private let courseCountPerDay = 7
    private let workDayCountPerWeek = 5
    private var courses: [Matrix<Course>] {
        didSet {
            let schedules = courses.enumerated().flatMap { (section, matrix) -> [Schedule] in
                
                return matrix.grid.enumerated().map { index, course in
                    let (row, column) = matrix.convert(index: index)
                    let gradeClass = GradeClass(grade: 1, classInGrade: column + 1)
                    let time = ScheduleTime(day: section + 1, order: row + 1)
                    return Schedule(course: course, time: time, gradeClass: gradeClass)
                }
            }
            
            let emptyCourse = Course()
            modelController.schedules = schedules.filter { $0.course != emptyCourse }
        }
    }
    private let modelController: ModelController
    
    init(_ modelController: ModelController) {
        self.modelController = modelController
        let coursesPerDay = Matrix(repeating: Course(), rows: courseCountPerDay, columns: classCountPerGrade)
        courses = Array(repeating: coursesPerDay, count: workDayCountPerWeek)
        super.init()
        reloadCourses()
    }
    
    private func reloadCourses() {
        
        for schedule in modelController.schedules {
            let row = schedule.time.order - 1
            let column = schedule.gradeClass.classInGrade - 1
            let section = schedule.time.day - 1
            courses[section][row, column] = schedule.course
        }
    }
    
}

extension CourseTableDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchoolCourseCell", for: indexPath) as! SchoolCourseCell
        let cellData = SchoolCourseCell.ViewModel(course: courses[indexPath.section][indexPath.item])
        cell.viewModel = cellData
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: CourseTableLayout.Element.TableHeader.kind, withReuseIdentifier: "CourseTableHeader", for: indexPath) as! CourseTableHeaderView
        view.label.text = "星期\(indexPath.section + 1)"
        return view
    }
    
}

extension CourseTableDataSource: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let course = courses[indexPath.section][indexPath.item]
        let courseObject = CourseItemProvider(course)
        let item = NSItemProvider(object: courseObject)
        let dragItem = UIDragItem(itemProvider: item)
        dragItem.localObject = indexPath
        return [dragItem]
    }
}

extension CourseTableDataSource: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        if let dragItem = coordinator.session.items.first {
            if let sourceIndexPath = dragItem.localObject as? IndexPath {
                courses[sourceIndexPath.section][sourceIndexPath.row] = Course()
                collectionView.reloadItems(at: [sourceIndexPath])
            }
        }
        
        
        if coordinator.session.canLoadObjects(ofClass: CourseItemProvider.self) {
            coordinator.session.loadObjects(ofClass: CourseItemProvider.self) { [weak self] courseItemProviders in
                if let courseItemProvider = courseItemProviders.first as? CourseItemProvider {
                    self?.courses[destinationIndexPath.section][destinationIndexPath.row] = courseItemProvider.value
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


