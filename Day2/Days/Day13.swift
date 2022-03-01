//
//  Day13.swift
//  Day2
//
//  Created by Alex Astilean on 13/12/2020.
//

import Foundation

class Day13: Day {
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay13", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let lines = string?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) else {
            return
        }
        day13Part1(lines: lines)
        day13Part2(lines: lines)

//        let buses = lines[1].components(separatedBy: ",")
//        for (index, bus) in buses.enumerated() {
//            if bus != "x" {
//                print(bus,index)
//            }
//        }
        
    }
    
    func day13Part2(lines: [String]) {
        print("PART 2 -----")
        let busesByIndex = lines[1].components(separatedBy: ",")
            .enumerated()
            .filter { $0.element != "x" }
            .map { (index: $0.offset, busId: Int($0.element)!)}
            .sorted { $0.busId > $1.busId }

        
        var step = busesByIndex.map{ $0.busId }.max()!
        
        var time = 0
        
        checkNextTime: while true {
            time += step

            step = 1
            for (index, busId) in busesByIndex {
                guard (time + index) % busId == 0 else { continue checkNextTime }
                step = max(step, step * busId)
            }
            break
        }
        print("PART 2 ------- ")
        print("RESULT = \(time)")
    }
    
    func day13Part1(lines: [String]) {
        
        let timestamp = Int(lines[0])!
        let buses = lines[1].components(separatedBy: ",").compactMap { Int($0) }
        var waitTime = Int.max
        var busId = 0
        
        for bus in buses {
            
            let thisWaitTime = bus - (timestamp % bus)
            if thisWaitTime < waitTime {
                waitTime = thisWaitTime
                busId = bus
            }
        }
        print("PART 1 ------- ")
        print("\(busId), \(waitTime)")
        print("RESULT = \(busId * waitTime)")
    }
}
