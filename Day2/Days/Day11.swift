//
//  Day11.swift
//  Day2
//
//  Created by Alex Astilean on 10/12/2020.
//

import Foundation

class Day11: Day {
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay11", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let lines = string?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) else {
            return
        }
        
        var matrix = [[String]]()
        
        lines.forEach {
            matrix.append($0.map { String($0) })
        }
        var isPart2 = true
        
        print("RUNNING PART \(isPart2 ? "TWO" : "ONE")")
        var count = 0
        var newMatrix: [[String]] = matrix
        repeat {
            matrix = newMatrix
            count += 1
            newMatrix = day11Iterate(matrix: matrix, part2: isPart2)
//            newMatrix.forEach {
//                print($0)
//            }
//            print("\n")
        } while newMatrix != matrix;
        
        var occupied = 0
        newMatrix.forEach { line in
            line.forEach { occupied += $0 == "#" ? 1: 0 }
        }
        print("COUNT = \(count)")
        print("OCCUPIED = \(occupied)")
    }
    
    func day11Iterate(matrix: [[String]], part2: Bool) -> [[String]] {
        
        var newMatrix: [[String]] = []
        
        for (lineIndex, line) in matrix.enumerated() {
            
            newMatrix.append([])
            for (colIndex, item) in line.enumerated() {
                
                if item == "." {
                    newMatrix[lineIndex].append(item)
                } else if item == "L" {
                    
                    if part2 ? day11AdiacentOcuppied2(matrix: matrix, lineIndex, colIndex) == 0 :
                        day11AdiacentOcuppied(matrix: matrix, lineIndex, colIndex) == 0 {
                        newMatrix[lineIndex].append("#")
                    } else {
                        newMatrix[lineIndex].append("L")
                    }
                    
                } else if item == "#" {
                    
                    if part2 ? day11AdiacentOcuppied2(matrix: matrix, lineIndex, colIndex) >= 5 :
                        day11AdiacentOcuppied(matrix: matrix, lineIndex, colIndex) >= 4 {
                        newMatrix[lineIndex].append("L")
                    } else {
                        newMatrix[lineIndex].append("#")
                    }
                } else {
                    print("FAIL \(item)")
                    return []
                }
            }
        }
        return newMatrix
    }
    
    func day11AdiacentOcuppied2(matrix: [[String]], _ lineIndex: Int, _ colIntex: Int) -> Int {
       
        func day11Itemfrom(matrix: [[String]], _ lineIndex: Int, _ colIntex: Int) -> String {
            
            if matrix.indices.contains(lineIndex),
               matrix[lineIndex].indices.contains(colIntex) {
                
                return matrix[lineIndex][colIntex]
            }
            return "L"
        }
        
        var result = 0
        
        // UP
        for line in 0..<lineIndex {
            
            let seenItem = matrix[lineIndex - line - 1][colIntex]
            if seenItem == "L" {
                break
            } else if seenItem == "#" {
                result += 1
                break
            }
        }
        
        //DOWN
        for line in lineIndex+1..<matrix.count {
            
            let seenItem = matrix[line][colIntex]
            if seenItem == "L" {
                break
            } else if seenItem == "#" {
                result += 1
                break
            }
        }
        
        // LEFT
        for col in 0..<colIntex {
            let seenItem = matrix[lineIndex][colIntex - col - 1]
            if seenItem == "L" {
                break
            } else if seenItem == "#" {
                result += 1
                break
            }
        }
        // RIGHT
        for col in colIntex+1..<matrix[lineIndex].count {
            let seenItem = matrix[lineIndex][col]
            if seenItem == "L" {
                break
            } else if seenItem == "#" {
                result += 1
                break
            }
        }
        
        //DOWN RIGHT
        lines: for line in lineIndex+1..<matrix.count {
            let seenItem = day11Itemfrom(matrix: matrix, line,  colIntex + line - lineIndex)
            
                if seenItem == "L" {
                    break lines
                } else if seenItem == "#" {
                    result += 1
                    break lines
                }
        }
        
        //DOWN LEFT
        lines: for line in lineIndex+1..<matrix.count {
            
            let seenItem = day11Itemfrom(matrix: matrix, line,  colIntex - line + lineIndex)
            
            if seenItem == "L" {
                break lines
            } else if seenItem == "#" {
                result += 1
                break lines
            }
        }
        
        //UP LEFT
        lines: for line in 0..<lineIndex {
            
            let seenItem = day11Itemfrom(matrix: matrix, lineIndex - line - 1, colIntex - line - 1)
            if seenItem == "L" {
                break lines
            } else if seenItem == "#" {
                result += 1
                break lines
            }
        }
        
        
        //UP RIGHT
        lines: for line in 0..<lineIndex {
            
            let seenItem = day11Itemfrom(matrix: matrix, lineIndex - line - 1, colIntex + line + 1)
            if seenItem == "L" {
                break lines
            } else if seenItem == "#" {
                result += 1
                break lines
            }
        }
        return result
    }
    
    func day11isEmptySeat(matrix: [[String]], _ lineIndex: Int, _ colIntex: Int) -> Bool {
        
        if matrix.indices.contains(lineIndex),
           matrix[lineIndex].indices.contains(colIntex) {
           return matrix[lineIndex][colIntex] != "#"
        }
        
        return true
    }
    
    func day11AdiacentOcuppied(matrix: [[String]], _ lineIndex: Int, _ colIntex: Int) -> Int {
        
        let combinations: [(Int, Int)] = [
            (lineIndex - 1, colIntex),
            (lineIndex - 1, colIntex + 1),
            (lineIndex - 1, colIntex - 1),
            (lineIndex, colIntex + 1),
            (lineIndex, colIntex - 1),
            (lineIndex + 1, colIntex),
            (lineIndex + 1, colIntex - 1),
            (lineIndex + 1, colIntex + 1)
        ]
        var result = 0
        for comb in combinations {
            
            result += day11isEmptySeat(matrix: matrix, comb.0, comb.1) ? 0: 1
        }
        return result
    }
}
