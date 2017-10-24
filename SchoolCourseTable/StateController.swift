//
//  StateController.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/10/18.
//  Copyright © 2017年 partrick. All rights reserved.
//

import Foundation

class StateController {
    
    static let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static var logsURL: URL {
        return documentDirectoryURL
            .appendingPathComponent("Logs")
            .appendingPathExtension("plist")
    }
    
    var teachers: [Teacher] {
        didSet {
            let encoder = PropertyListEncoder()
            do {
                let data = try encoder.encode(teachers)
                try data.write(to: StateController.logsURL)
            } catch  {
                print(error)
            }
        }
    }
    
    var availableCourses: [Course] {
        let courses = teachers.flatMap { teacher in
            return teacher.capableSubjects.map { subject in
                Course(teacher: teacher,subject: subject)
            }
        }
        
        return courses.sorted { $0.subject.rawValue > $1.subject.rawValue }
    }
    
    var courses = Array(repeating: Course(), count: 30)

    
    init() {
        teachers = StateController.loadTeachers()
    }
    
    class func loadTeachers() -> [Teacher] {
        let data = try! Data(contentsOf: logsURL)
        let decoder = PropertyListDecoder()
        let decoded = try! decoder.decode([Teacher].self, from: data)
        return decoded
    }
    
    func reloadTeachers() {
        let data = try! Data(contentsOf: StateController.logsURL)
        let decoder = PropertyListDecoder()
        let decoded = try! decoder.decode([Teacher].self, from: data)
        self.teachers = decoded
    }
}
