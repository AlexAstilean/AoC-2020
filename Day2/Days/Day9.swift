//
//  Day9.swift
//  Day2
//
//  Created by Alex Astilean on 09/12/2020.
//

import Foundation

class Day9: Day {
    
    func run() {
        
        let preamble = 25
        
        let path = Bundle.main.path(forResource: "inputDay9", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let numbersString = string?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) else {
            return
        }
        let numbers = numbersString.compactMap { Int($0) }
        
        var invalidNumber = 0
        
        // Part 1
        for i in preamble..<numbers.endIndex {
            let previous25 = Array(numbers[i-preamble...i-1])
            
            let isSum = day9Validate(sum: numbers[i], from: previous25)
            if !isSum {
                invalidNumber = numbers[i]
                print("STOPPED at \(numbers[i])")
                break
            }
        }
        
        
        iteration: for (index, _) in numbers.enumerated() {
            
            print(index)
            var r = index + 1
            
            while r < numbers.count {
                
                let subSet = Array(numbers[index...r])
                if subSet.reduce(0, +) == invalidNumber {
                    print("FOUND SET \(subSet) | weakness: \(subSet.min()! + subSet.max()!)")
                    break iteration
                    
                } else {
                    r += 1
                }
            }
        }
    }
    
    func day9Validate(sum: Int, from numbers: [Int]) -> Bool {
        
        let sorted = numbers.sorted()
        
        var l = 0
        var r = sorted.count - 1
        
        while l < r {
            if sorted[l] + sorted[r] == sum {
                return true
            } else if sorted[l] + sorted[r] < sum {
                l += 1
            } else {
                r -= 1
            }
        }
        return false
    }
}
