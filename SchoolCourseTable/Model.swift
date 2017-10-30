//
//  Model.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/9/27.
//  Copyright © 2017年 partrick. All rights reserved.
//

import Foundation

enum Subject: String, Codable {
    case chinese = "语文"
    case math = "数学"
    case english = "英语"
    case art = "美术"
    case physical = "体育"
    case music = "音乐"
    case blank = ""
}

struct Teacher: Codable {
    let name: String
    let subjectCount: [Subject: Int]
}

// Course

struct Course: Codable {
    var teacher: Teacher
    let subject: Subject
    
}

struct GradeClass: Codable {
    let grade: Int
    let classInGrade: Int
}

struct ScheduleTime: Codable {
    let day: Int
    let order: Int
}

// Course Schedule

//struct Schedule: Codable {
//    let course: Course
//    let time: ScheduleTime
//    let gradeClass: GradeClass
//}

// Wrapper Class of Course for NSItemProvider

final class CourseItemProvider: NSObject {
    let course: Course
    
    init(_ course: Course) {
        self.course = course
    }
    
    var value: Course {
        return course
    }
}

// all case and random case

extension Subject {
    
    static var all: [Subject] {
        return [.chinese, .math, .english, .art, .physical, .music]
    }
    
    static var random: Subject {
        let count = all.count
        let randomIndex = Int(arc4random()) % count
        return all[randomIndex]
    }
    
    static var indexDict: [Subject: Int] {
        let pairs = zip(all, Array(0..<all.count))
        let dict = Dictionary(uniqueKeysWithValues: pairs)
        return dict
    }
    
}

extension Course {
    init() {
        let teacher = Teacher(name: "", subjectCount: [:])
        self = Course(teacher: teacher, subject: .blank)
    }
}

extension Course: CustomStringConvertible {
    var description: String {
        return "\(subject.rawValue): \(teacher.name)"
    }
}

extension GradeClass: Hashable {
    var hashValue: Int {
        return grade * 1024 + classInGrade
    }
    
    static func ==(lhs: GradeClass, rhs: GradeClass) -> Bool {
        return lhs.grade == rhs.grade && lhs.classInGrade == rhs.classInGrade
    }
    
}

extension ScheduleTime: Hashable {
    var hashValue: Int {
        return day * 1024 + order
    }
    
}

extension CourseItemProvider: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        return ["com.partrick.course"]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> CourseItemProvider {
        let decoder = JSONDecoder()
        if let course = try? decoder.decode(Course.self, from: data) {
            return CourseItemProvider(course)
        }
        return CourseItemProvider(Course(teacher: Teacher(name: "", subjectCount: [:]), subject: .blank))
    }
    
    
}

extension CourseItemProvider: NSItemProviderWriting {
    static var writableTypeIdentifiersForItemProvider: [String] {
        return ["com.partrick.course"]

    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(course)
        completionHandler(data, nil)
        return nil
    }
    
    
}

// Teacher Description

extension Teacher: CustomStringConvertible {
    
    var description: String {
        let subjects = subjectCount.reduce("") { result, subject in
            return result + "#" + "\(subject.key.rawValue) - \(subject.value)"
        }
        return "\(name): \(subjects)"
    }

}

// Equatable

extension Course: Equatable {
    static func ==(lhs: Course, rhs: Course) -> Bool {
        return lhs.teacher.name == rhs.teacher.name && lhs.subject == rhs.subject
    }
}

extension ScheduleTime: Equatable {
    static func ==(lhs: ScheduleTime, rhs: ScheduleTime) -> Bool {
        return lhs.day == rhs.day && lhs.order == rhs.order
    }
}

extension Teacher: Equatable {
    static func ==(lhs: Teacher, rhs: Teacher) -> Bool {
        return lhs.name == rhs.name && lhs.subjectCount == rhs.subjectCount
    }
}




















