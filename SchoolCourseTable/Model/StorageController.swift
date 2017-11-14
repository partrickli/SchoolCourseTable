//
//  Storage.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/11/8.
//  Copyright © 2017年 partrick. All rights reserved.
//

import Foundation

class StorageController {
    
    struct Resource<Model: Codable> {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let urlFileName: String
        var url: URL {
            return documentDirectoryURL.appendingPathComponent("teachers").appendingPathExtension("plist")
        }
        
        func save(value: [Model]) {
            if let data = value.encodeToPlist() {
                try? data.write(to: url)
            }
        }
        
        func reload() -> [Model]? {
            if let data = try? Data(contentsOf: url) {
                return [Model].decodeFromPlist(data: data)
            }
            return nil
        }

    }
    
    let schedulesResource = Resource<Schedule>(urlFileName: "schedules")
    let teachersResource = Resource<Teacher>(urlFileName: "teachers")

}

extension StorageController {
    var availableCourses: [Course] {
        if let teachers: [Teacher] = teachersResource.reload() {
            let courses = teachers.flatMap { teacher -> [Course] in
                let nonzeroSubjects = teacher.subjectCount.filter { $0.value > 0 }.keys
                return nonzeroSubjects.map { Course(teacher: teacher, subject: $0) }
            }
            return courses
        } else {
            return []
        }
    }
    
    var allSchedules: [Schedule]? {
        return schedulesResource.reload()
    }
}

extension Array {
    
    func encodeToPlist() -> Data? {
        return try? PropertyListEncoder().encode(self)
    }
    
    static func decodeFromPlist(data: Data) -> Array? {
        return try? PropertyListDecoder().decode([Element].self, from: data)
    }
    
}


