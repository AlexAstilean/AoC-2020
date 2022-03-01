//
//  Day15.swift
//  Day2
//
//  Created by Alex Astilean on 15/12/2020.
//

import Foundation

class Day15: Day {
    
    func run() {
        
        let input = [10, 16,6,0,1,17]
        //Part 1
        print("Part 1 Result = \(numbers(input: input, maxTurns: 2020))")
        //Part 2
        print("Part 2 Result = \(numbers(input: input, maxTurns: 30_000_000))")

    }
    
    func numbers(input: [Int], maxTurns: Int) -> Int {
        
        var numberLastSpoken = [Int:Int]() // [Number:Turn]

        for (turn, number) in input.enumerated() {
            numberLastSpoken[number] = turn + 1
        }
        
        var turn = input.count
        var previousNumber = input.last!
        
        while true {
            turn += 1
            let lastSpoken = numberLastSpoken[previousNumber] ?? (turn - 1)
            let numberToSpeak = turn - 1 - lastSpoken
            
            numberLastSpoken[previousNumber] = turn - 1
            previousNumber = numberToSpeak
            
            guard turn < maxTurns else {
                return numberToSpeak
            }
        }
    }
}
