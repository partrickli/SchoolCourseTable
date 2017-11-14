//
//  DataStructure.swift
//  SchoolCourseTable
//
//  Created by liguiyan on 2017/11/7.
//  Copyright © 2017年 partrick. All rights reserved.
//

import Foundation

struct Matrix<Element> {
    
    let rows: Int, columns: Int
    var grid: [Element]
    
    init(repeating element: Element, rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: element, count: rows * columns)
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> Element {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
    
    subscript(index: Int) -> Element {
        
        get {
            return grid[index]
        }
        
        set {
            grid[index] = newValue
        }
    }
    
    func convert(index: Int) -> (row: Int, column: Int) {
        let row = index / columns
        let column = index % columns
        return (row, column)
    }
    
    var count: Int {
        return grid.count
    }
}
