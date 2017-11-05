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
    
    static var scheduleURL: URL {
        return documentDirectoryURL.appendingPathComponent("schedule").appendingPathExtension("plist")
    }
    
    let classCountPerGrade = 5
    let coursePerDay = 7
    
    var totalCoursePerDay: Int {
        return classCountPerGrade * coursePerDay
    }
    
    var teachers: [Teacher] {
        didSet {
            teachers.savePlist(to: StateController.logsURL)
        }
    }
    
    var schedules: [Schedule] {
        didSet {
            schedules.savePlist(to: StateController.scheduleURL)
        }
    }
    
    var availableCourses: [Course] {
        let courses = teachers.flatMap { teacher in
            return teacher.subjectCount.keys.map { subject in
                Course(teacher: teacher,subject: subject)
            }
        }
        
        return courses.sorted { $0.subject.rawValue > $1.subject.rawValue }
    }
    
    
    init() {
        teachers = StateController.reload(from: StateController.logsURL)
        schedules = StateController.reload(from: StateController.scheduleURL)
    }
    
    static func reload<T>(from url: URL) -> [T] {
        guard let data = try? Data(contentsOf: url) else {
            return []
        }
        let decoder = PropertyListDecoder()
        if let decoded = try? decoder.decode([T].self, from: data) {
            return decoded
        } else {
            return []
        }
    }
    
    func reloadData() {
        self.teachers = StateController.reload(from: StateController.logsURL)
        self.schedules = StateController.reload(from: StateController.scheduleURL)
    }
    
}


extension Array {
    func savePlist(to url: URL) {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self)
            try data.write(to: url)
        } catch  {
            print(error)
        }
    }
}
