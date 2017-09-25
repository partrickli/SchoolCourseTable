//
//  FirstViewController.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/9/25.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    let courses = Array(repeating: "语文", count: 30)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let colors: [UIColor] = [.green, .blue, .red, .orange, .yellow]


}

extension FirstViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchoolCourseCell", for: indexPath) as! SchoolCourseCell
        cell.courseLabel.text = courses[indexPath.item]
        return cell
    }
    

}
