//
//  CourseTableHeaderView.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/9/28.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class CourseTableHeaderView: UICollectionReusableView {
    
    let label: UILabel = {
        let l = UILabel()
        l.text = "星期一"
        l.textColor = .gray
        l.font = UIFont.preferredFont(forTextStyle: .headline)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let classOfGrade = (1...5).map { c -> UILabel in
        let l = UILabel()
        l.text = "\(c)班"
        l.textColor = .gray
        l.textAlignment = .center
        l.font = UIFont.preferredFont(forTextStyle: .headline)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }
    
    let classStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .equalCentering
        return sv
    }()
    
    let verticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        verticalStackView.addArrangedSubview(label)
        verticalStackView.addArrangedSubview(classStackView)
        for l in classOfGrade {
            classStackView.addArrangedSubview(l)
        }
        addSubview(verticalStackView)
        verticalStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        verticalStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        verticalStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
