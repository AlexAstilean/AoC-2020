//
//  Day7.swift
//  Day2
//
//  Created by Alex Astilean on 07/12/2020.
//

import Foundation

class Day7: Day {
    
    struct Bag {
        let number: Int
        let color: String
    }
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay7", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard var lines = string?.components(separatedBy: .newlines) else { return }
        lines.removeAll(where: { $0.isEmpty })
        
        let parentChild = lines.map { $0.components(separatedBy: "contain") }
        
        let bags = parentChild.reduce([String: [Bag]]()) { result, item -> [String: [Bag]] in
            
            var bags = result
            let key = item[0].replacingOccurrences(of: "bags ", with: "bag")
            let values = item[1].replacingOccurrences(of: "bags", with: "bag").replacingOccurrences(of: ".", with: "").components(separatedBy: ", ")
            bags[key] = values.compactMap { item -> Bag? in
                let value = item.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
                guard let number = Int(value[0]) else {
                    
                    print("FAIL \(value) \(key)")
                    return nil
                }
                return Bag(number: number, color: String(value[1]))
            }
            return bags
        }
        
        let nr = searchDay7Part2(bagName: "shiny gold bag", in: bags)
        print(nr)
    }
    
    func searchDay7Part2(bagName: String, in bags: [String: [Bag]]) -> Int {
        
        guard let bagsInside = bags[bagName] else {
            print("NOT FOUND \(bagName)")
            return 0
        }
        var sum = 0
        bagsInside.forEach {
            let bagsInside = searchDay7Part2(bagName: $0.color, in: bags)
            sum = sum + $0.number + ($0.number * bagsInside)
        }
        return sum
    }
    
    func day7FirstHalf(parentChild: [[String]]) {
        
        var containing = Set<String>()
        
        let c = passDay7(elements: ["shiny gold"], in: parentChild)
        
        c.forEach {
            containing.insert($0)
        }
        for _ in 1...100 {
            let c = passDay7(elements: Array(containing), in: parentChild)
            c.forEach {
                containing.insert($0)
            }
        }
        print(containing)
    }
    
    func passDay7(elements: [String], in parentChild: [[String]]) -> [String] {
        
        var containing: [String] = []
        
        parentChild.forEach { child in
            
            elements.forEach { element in
                if child[1].contains(element) {
                    containing.append(child[0].replacingOccurrences(of: "bags ", with: "bag"))
                }
            }
        }
        return containing
    }
}
