//
//  Day18.swift
//  AoC2020
//
//  Created by Alex Astilean on 18/12/2020.
//

import Foundation

class Day18: Day {
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay18", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let inputLines = string?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) else {
            return
        }
        var part1 = 0
        var part2 = 0
        for line in inputLines {
            var l1 = line[...]
            part1 += evaluate1(&l1)
            
            var l2 = line[...]
            part2 += evaluate2(&l2)
        }
        
        print("Part 1 Result: \(part1)")
        print("Part 2 Result: \(part2)")

    }
    func evaluate1(_ string: inout Substring) -> Int {
        var value = 0
        var adding = true
        
        while let c = string.popFirst(), c != ")" {
            switch c {
            case " ":
                break
            case "+", "*":
                adding = c == "+"
            default:
                let n = Int(String(c)) ?? evaluate1(&string)
                adding ? (value += n) : (value *= n)
            }
        }
        
        return value
    }

    func evaluate2(_ string: inout Substring) -> Int {
        var product = 1
        var sum = 0
        
        while let c = string.popFirst(), c != ")" {
            switch c {
            case " ", "+":
                break
            case "*":
                product *= sum
                sum = 0
            default:
                sum += Int(String(c)) ?? evaluate2(&string)
            }
        }
        
        product *= sum
        return product
    }
}
