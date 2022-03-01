//
//  Day10.swift
//  Day2
//
//  Created by Alex Astilean on 10/12/2020.
//

import Foundation

class Day10: Day {
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay10", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let numbersString = string?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) else {
            return
        }
        var joltages = numbersString.compactMap { Int($0) }
        let deviceJoltaje = joltages.max()! + 3
        joltages.append(deviceJoltaje)
        joltages.append(0)
        joltages.sort()
        
        var differencesJolts: [Int: Int] = [:]
        
        for index in 1..<joltages.count {
            let difference = joltages[index] - joltages[index - 1]
            differencesJolts[difference] = (differencesJolts[difference] ?? 0) + 1
        }
        print(joltages)
        
        print(differencesJolts)
        print("Multiplied: \(differencesJolts[1]! * differencesJolts[3]!)")
        
        
        print("PART 2 ---------- \n")
        
//        joltages.removeFirst()
        
//        print(day10Part2(joltajes: joltages, currentRes: [], savedPermutations: [:]))
        day10Try2(joltages: joltages.reversed(), savedPermutations: [:])
        print("FINISHED")
    }
    
    func day10Try2(joltages: [Int], savedPermutations: [Int: [[Int]]]) {
        
        var permutationsNr = [Int:Int]()
        
        for (index, joltage) in joltages.enumerated()  {
            
            var permutation = 0
            if joltages.indices.contains(index - 1) {
                let previous = joltages[index - 1]
                
                if let previousPerm = permutationsNr[previous] {
                    permutation = permutation + previousPerm
                } else {
                    permutation = 1
                }
                
//                if let savedPrevious = savedPerm[previous] {
//                    savedPrevious.forEach {
//                        if savedPerm[joltage] != nil {
//                            savedPerm[joltage]?.append([previous] + $0)
//                        } else {
//                            savedPerm[joltage] = [[previous] + $0]
//                        }
//                    }
//
//                } else {
//                    savedPerm[joltage] = [[previous]]
//                }
                permutationsNr[joltage] = permutation

            }
            
            if joltages.indices.contains(index - 2), joltages[index - 2] - joltage <= 3 {
                let previous = joltages[index - 2]
                
                if let previousPerm = permutationsNr[previous] {
                    permutation = permutation + previousPerm
                } else {
                    permutation = 1
                }
                
//                if let savedPrevious = savedPerm[previous] {
//                    savedPrevious.forEach {
//                        if savedPerm[joltage] != nil {
//                            savedPerm[joltage]?.append([previous] + $0)
//                        } else {
//                            savedPerm[joltage] = [[previous] + $0]
//                        }
//                    }
//
//                } else {
//                    savedPerm[joltage] = [[previous]]
//                }
                permutationsNr[joltage] = permutation

                
            }
            if joltages.indices.contains(index - 3), joltages[index - 3] - joltage <= 3 {
                let previous = joltages[index - 3]
                
                if let previousPerm = permutationsNr[previous] {
                    permutation = permutation + previousPerm
                } else {
                    permutation = 1
                }
                
//                if let savedPrevious = savedPerm[previous] {
//                    savedPrevious.forEach {
//                        if savedPerm[joltage] != nil {
//                            savedPerm[joltage]?.append([previous] + $0)
//                        } else {
//                            savedPerm[joltage] = [[previous] + $0]
//                        }
//                    }
//                    savedPerm[previous] = nil
//                } else {
//                    savedPerm[joltage] = [[previous]]
//                }
                permutationsNr[joltage] = permutation

            }
            
        }
        print("COUNT = \(permutationsNr[0]!)")
    }
}
