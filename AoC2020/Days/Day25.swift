//
//  Day25.swift
//  AoC2020
//
//  Created by Alex Astilean on 25/12/2020.
//

import Foundation

class Day25: Day {
    
    func run() {
        
        let cardKey = 5099500
        let doorKey = 7648211
        
        let loopSizeCard = loopSize(forKey: cardKey)
        let loopSizeDoor = loopSize(forKey: doorKey)
        
        let privateKey1 = compute(subjectNumber: doorKey, loopSize: loopSizeCard)
        let privateKey2 = compute(subjectNumber: cardKey, loopSize: loopSizeDoor)
        
        print("Equal keys: \(privateKey1 == privateKey2)")
        print("RESULT PART 1: \(privateKey1)")
        print("RESULT PART 2: Merry Christmas")
    }
    
    func loopSize(forKey key: Int) -> Int {
        
        let subject = 7
        var value = 1
        var loops = 0
        
        while value != key {
            
            value *= subject
            value %= 2020_12_27
            loops += 1
        }
        return loops
    }
    
    func compute(subjectNumber: Int, loopSize: Int) -> Int {
        
        var value = 1
        
        for _ in 0..<loopSize {
            value *= subjectNumber
            value %= 2020_12_27
        }
        return value
    }
}
