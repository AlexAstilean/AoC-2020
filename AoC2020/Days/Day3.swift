//
//  Day3.swift
//  AoC2020
//
//  Created by Alex Astilean on 03/12/2020.
//

import Foundation

class Day3: Day {
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay3", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let lines = string?.components(separatedBy: .newlines) else {
            print("No components")
            return
        }
        var matrix = [[String]]()
        
        for element in lines {
            
            guard !element.isEmpty else { continue }
            matrix.append(element.map { String($0) })
        }
        
        print("Right 1, down 1: \(day3Iterate(matrix: matrix, columnSlope: 1, lineSlope: 1))")
        print("Right 3, down 1: \(day3Iterate(matrix: matrix, columnSlope: 3, lineSlope: 1))")
        print("Right 5, down 1: \(day3Iterate(matrix: matrix, columnSlope: 5, lineSlope: 1))")
        print("Right 7, down 1: \(day3Iterate(matrix: matrix, columnSlope: 7, lineSlope: 1))")
        print("Right 1, down 2: \(day3Iterate(matrix: matrix, columnSlope: 1, lineSlope: 2))")
    }
    
    func day3Iterate(matrix: [[String]], columnSlope: Int, lineSlope: Int) -> Int {
        
        var trees = 0
        var colIndex = 0
        var lineIndex = 0
        while lineIndex < matrix.count {
            
            if matrix[lineIndex][colIndex] == "#" {
                trees += 1
            }
            colIndex = (colIndex + columnSlope) % matrix[lineIndex].count
            lineIndex += lineSlope
        }
        return trees
    }
}
