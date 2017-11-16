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
        courseTableCollectionView.dragDelegate = courseTableDataSource
        courseTableCollectionView.dropDelegate = courseTableDataSource

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






extension CourseTableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}










