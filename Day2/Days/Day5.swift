//
//  Day5.swift
//  Day2
//
//  Created by Alex Astilean on 07/12/2020.
//

import Foundation

class Day5: Day {
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay5", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let tickets = string?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) else {
            return
        }
        
        var seatId = [Int]()
        var maxSeatId = 0
        
        tickets.forEach { ticket in
            
            let row = ticket.prefix(7)
            let col = ticket.suffix(3)
            
            var rowNumber = 0...127
            var colNumber = 0...7
            row.forEach { char in
                let half = (rowNumber.lowerBound + rowNumber.upperBound) / 2
                if char == "F" {
                    rowNumber = rowNumber.lowerBound...half
                } else if char == "B" {
                    rowNumber = half+1...rowNumber.upperBound
                }
            }
            col.forEach { char in
                let half = (colNumber.lowerBound + colNumber.upperBound)/2
                if char == "L" {
                    colNumber = colNumber.lowerBound...half
                } else if char == "R" {
                    colNumber = half+1...colNumber.upperBound
                }
            }
            guard rowNumber.count == 1, colNumber.count == 1 else {
                print("FAIL")
                return
            }
            let seatIdNr = rowNumber.lowerBound * 8 + colNumber.lowerBound
            seatId.append(seatIdNr)
            maxSeatId = maxSeatId < seatIdNr ? seatIdNr: maxSeatId
        }
        print(maxSeatId)
        
        for i in 0...maxSeatId {
            if !seatId.contains(i) {
                print(i)
            }
        }
    }
    
    
}
