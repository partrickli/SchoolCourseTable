//
//  CourseSelectionDataSource.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/11/14.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit


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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchoolCourseCell", for: indexPath) as! SchoolCourseCell
        
        cell.viewModel = SchoolCourseCell.ViewModel(course: courses[indexPath.item])
        return cell
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
