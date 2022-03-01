//
//  Day17.swift
//  Day2
//
//  Created by Alex Astilean on 16/12/2020.
//

import Foundation

class Day17: Day {
    
    struct Coordinates4D: Hashable {
        var w: Int
        var x: Int
        var y: Int
        var z: Int
    }
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay17", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let inputLines = string?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) else {
            return
        }
        var activeCubes = Set<Coordinates4D>()
        var nextActiveCubes = Set<Coordinates4D>()
        
        for(rowIndex, row) in inputLines.enumerated() {
            for (colIndex, char) in row.enumerated() where char == "#" {
                nextActiveCubes.insert(Coordinates4D(w: 0, x: colIndex, y: rowIndex, z: 0))
            }
        }
        activeCubes = nextActiveCubes
        
        print("Part 1 Result: \(cubes(activeCubes, nextActiveCubes, cycles: 6, part2: false))")
        print("Part 2 Result: \(cubes(activeCubes, nextActiveCubes, cycles: 6, part2: true))")
    }
    
    func cubes(_ activeCubes: Set<Coordinates4D>,
               _ nextActiveCubes: Set<Coordinates4D>,
               cycles: Int,
               part2: Bool) -> Int {
        
        var activeCubes = activeCubes
        var nextActiveCubes = nextActiveCubes
        
        for _ in 1...cycles {
            nextActiveCubes.removeAll()
            var cubesToCheck = Dictionary<Coordinates4D, Int>()
            
            for cube in activeCubes {
                for neighbor in allNeighbors(of: cube, isPart2: part2) {
                    cubesToCheck[neighbor] = (cubesToCheck[neighbor] ?? 0) + 1
                }
            }
            
            for (cube, activeNeighborCount) in cubesToCheck {
                if activeCubes.contains(cube) {
                    if (activeNeighborCount == 2 || activeNeighborCount == 3) {
                        nextActiveCubes.insert(cube)
                    }
                } else {
                    if activeNeighborCount == 3 {
                        nextActiveCubes.insert(cube)
                    }
                }
            }
            
            activeCubes = nextActiveCubes
        }
        
        return activeCubes.count
    }
    
    func allNeighbors(of loc: Coordinates4D, isPart2: Bool) -> Set<Coordinates4D> {
        var r = Set<Coordinates4D>(minimumCapacity: 80)
        
        for w in [-1, 0, +1] {
            for x in [-1, 0, +1] {
                for y in [-1, 0, +1] {
                    for z in [-1, 0, +1] where !(x == 0 && y == 0 && z == 0 && w == 0) && (w == 0 || isPart2) {
                        r.insert(Coordinates4D(
                            w: loc.w + w,
                            x: loc.x + x,
                            y: loc.y + y,
                            z: loc.z + z
                        ))
                    }
                }
            }
        }
        
        return r
    }
}
