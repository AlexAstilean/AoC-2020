//
//  Day24.swift
//  AoC2020
//
//  Created by Alex Astilean on 24/12/2020.
//

import Foundation

class Day24: Day {
    
    struct Coordinate: Hashable {
        let x: Int
        let y: Int
        
        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }
        
        var neighbors: [Coordinate] {
            return [Coordinate(x - 2, y), Coordinate(x + 2, y), Coordinate(x + 1, y + 1), Coordinate(x - 1, y + 1), Coordinate(x + 1, y - 1), Coordinate(x - 1, y - 1)]
        }
    }
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay24", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let lines = string?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) else {
            return
        }
        let diagonalDirections = [
            "se": Coordinate(1,1),
            "sw": Coordinate(-1,1),
            "nw": Coordinate(-1,-1),
            "ne": Coordinate(1,-1),
        ]
        let lateralDirections = [
            "e": Coordinate(2,0),
            "w": Coordinate(-2,0)
        ]
        let coordinates = lines.map { pLine -> Coordinate in
            var relativeCoordinate = Coordinate(0,0)
            var line = pLine
            var substring = ""
            while line.count > 0 || substring.count > 0 {
                while line.count > 0 && substring.count < 2 {
                    substring.append(line.removeFirst())
                }
                var direction = diagonalDirections[substring]
                if direction == nil {
                    direction = lateralDirections[String(substring.first!)]
                    substring.removeFirst()
                } else {
                    substring.removeFirst()
                    substring.removeFirst()
                }
                relativeCoordinate = Coordinate(relativeCoordinate.x + direction!.x, relativeCoordinate.y + direction!.y)
            }
            return relativeCoordinate
        }
        
        
        let occurences = coordinates.reduce(into: [:]) { counts, coordinate in counts[coordinate, default: 0] += 1 }

        print("PART 1 Result: ")
        print(occurences.filter { $0.value % 2 == 1 }.count)
        
        
        
        var grid = Dictionary(uniqueKeysWithValues:occurences.map { ($0.key,$0.value % 2 == 1) }.filter { $0.1 })

        var newGrid = grid

        for _ in 0..<100 {
            grid = newGrid
            for element in grid {
                let coordinate = element.key
                for neighbor in coordinate.neighbors {
                    if grid[neighbor] == nil {
                        grid[neighbor] = false
                    }
                }
            }
            for element in grid {
                let coordinate = element.key
                var activeNeighbors = 0
                for neighbor in coordinate.neighbors {
                    if grid[neighbor] == true {
                        activeNeighbors += 1
                    } else {
                        if newGrid[neighbor] == nil {
                            newGrid[neighbor] = false
                        }
                    }
                }
                if grid[coordinate] == true {
                    if activeNeighbors == 0 || activeNeighbors > 2 {
                        newGrid[coordinate] = false
                    } else {
                        newGrid[coordinate] = true
                    }
                } else {
                    if activeNeighbors == 2 {
                        newGrid[coordinate] = true
                    } else {
                        newGrid[coordinate] = false
                    }
                }
            }
        }
        print("PART 2 RESULT:")
        print(newGrid.filter { $0.value }.count)
    }
}
