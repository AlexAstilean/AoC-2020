//
//  Day12.swift
//  Day2
//
//  Created by Alex Astilean on 12/12/2020.
//

import Foundation

class Day12: Day {
    
    enum Degrees: Int {
        
        case north = 0
        case east = 90
        case south = 180
        case west = 270
        
        init(_ n: Int) {
            
            if n >= 0 {
                self = Degrees(rawValue: n % 360)!
            } else {
                self = Degrees(rawValue: 360 + n)!
            }
        }
    }
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay12", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let lines = string?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) else {
            return
        }
        
        print("DAY12 PART 1 Result = \(day12part1(lines: lines))")
        print("DAY12 PART 2 Result = \(day12Part2(lines: lines))")

    }
    
    func day12part1(lines: [String]) -> Int {
        
        var ew = 0
        var ns = 0
        var degrees = Degrees.east
        
        for line in lines {
            
            let action = String(line.prefix(1))
            let value = Int(String(line.suffix(from: line.index(line.startIndex, offsetBy: 1))))!
            
            switch action {
            case "F":
                switch degrees {
                case .north: ns -= value
                case .south: ns += value
                case .east: ew += value
                case .west: ew -= value
                }
            case "N":
                ns -= value
            case "S":
                ns += value
            case "E":
                ew += value
            case "W":
                ew -= value
            case "L":
                degrees = Degrees(degrees.rawValue - value)
            case "R":
                degrees = Degrees(degrees.rawValue + value)
            default:
                print("UNKNOWN \(action)")
            }
        }
        
        return abs(ns) + abs(ew)
    }
    
    func day12Part2(lines: [String]) -> Int {
        
        func rotateRight(_ degr: Int, wp_ns: inout Int, wp_ew: inout Int) {
            
            var deg = degr
            if deg <= 0 {
                deg += 360
            }
            deg = deg % 360
            
            for _ in 1...Int(deg / 90) {
                let x_ns = wp_ns
                let x_ew = wp_ew
                
                wp_ew = x_ns * -1
                wp_ns = x_ew
            }
        }
        
        var wp_ew = 10
        var wp_ns = -1
        var ew = 0
        var ns = 0

        for inputLine in lines {
            var line = inputLine
            let action = line.removeFirst()
            let value = Int(line)!
            
            switch action {
            case "N": wp_ns -= value
            case "S": wp_ns += value
            case "E": wp_ew += value
            case "W": wp_ew -= value
            case "F":
                ew += wp_ew * value
                ns += wp_ns * value
            case "L": rotateRight(360 - value, wp_ns: &wp_ns, wp_ew: &wp_ew)
            case "R": rotateRight(value, wp_ns: &wp_ns, wp_ew: &wp_ew)
            default:
                print("UNKNOWN \(action)")
            }
            print("ship: ns \(ns) ew \(ew), waypoint: ns \(wp_ns) ew \(wp_ew)")
        }
        
        return abs(ns) + abs(ew)
    }
}
