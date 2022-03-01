//
//  Day1.swift
//  AoC2020
//
//  Created by Alex Astilean on 03/12/2020.
//

import Foundation

class Day1: Day {
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay1", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        let items = string?.components(separatedBy: .newlines).compactMap { Int($0) } ?? []
            
        var (first, second, third, product) = (0,0,0,0)
        
        // duplets
        for index in 0..<items.count - 1 {
            for j in index+1..<items.count {
                if items[index] + items[j] == 2020 {
                    first = items[index]
                    second = items[j]
                    product = items[index] * items[j]
                    
                    print("\(items[index]) and \(items[j])")
                }
            }
        }
        print("PART 1")
        print("\(first) * \(second) = \(product)")
        
        //triplets
        
        for index in 0..<items.count - 2 {
            for j in index+1..<items.count - 1 {
                for z in j+1..<items.count {
                    if items[index] + items[j] + items[z] == 2020 {
                        
                        first = items[index]
                        second = items[j]
                        third = items[z]
                        product = items[index] * items[j] * items[z]
                        
                        print("\(items[index]) + \(items[j]) + \(items[z])")
                    }
                }
            }
        }
        
        print("PART 2")
        print("\(first) * \(second) * \(third) = \(product)")
    }
}
