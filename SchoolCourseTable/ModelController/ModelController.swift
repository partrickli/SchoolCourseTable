//
//  Storage.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/11/8.
//  Copyright © 2017年 partrick. All rights reserved.
//

import Foundation

class ModelController {
    
    var teachers: [Teacher]
    var schedules: [Schedule]
    
    init() {
        teachers = teachersResource.reload() ?? []
        schedules = schedulesResource.reload() ?? []
    }
    
    static let shared = ModelController()
    
    // storage
    struct Resource<Model: Codable> {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let urlFileName: String
        var url: URL {
            return documentDirectoryURL.appendingPathComponent(urlFileName).appendingPathExtension("plist")
        }
        
        func save(value: [Model]) {
            if let data = value.encodeToPlist() {
                do {
                    try data.write(to: url)
                    print("saving \(type(of: value))succeeded.")
                    print(value)
                } catch {
                    print("saving \(value)")
                    print(error)
                }
            }
        }
        
        func reload() -> [Model]? {
            if let data = try? Data(contentsOf: url) {
                return [Model].decodeFromPlist(data: data)
            } else {
                return nil
            }
        }

    }
    
    let schedulesResource = Resource<Schedule>(urlFileName: "schedules")
    let teachersResource = Resource<Teacher>(urlFileName: "teachers")
    
    func save() {
        teachersResource.save(value: teachers)
        schedulesResource.save(value: schedules)
    }

}

extension ModelController {
    var availableCourses: [Course] {
        let courses = teachers.flatMap { teacher -> [Course] in
            let nonzeroSubjects = teacher.subjectCount.filter { $0.value > 0 }.keys
            return nonzeroSubjects.map { Course(teacher: teacher, subject: $0) }
        }
        return courses
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


