//
//  Day2.swift
//  Day2
//
//  Created by Alex Astilean on 03/12/2020.
//

import Foundation

class Day2: Day {
    
    struct Pass {

        var ruleRange: ClosedRange<Int>
        var ruleLetter: Character
        var password: String
        
        init?(entry: String) {
            
            let items = entry.components(separatedBy: .whitespaces)
            guard items.count == 3 else {
                print("ERROR: missing items for \(entry)")
                return nil
            }
            let range = items[0].components(separatedBy: "-").map { Int($0) }
            
            ruleRange = range[0]!...range[1]!
            ruleLetter = items[1].first!
            password = items[2]
        }
    }
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay2", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        let stringItems = string?.components(separatedBy: .newlines)
        
        let passwords = stringItems?.compactMap { Pass(entry: $0) }
        
        let valid = passwords?.filter({ item -> Bool in
            
            let occurences = item.password.lowercased().filter { $0 == item.ruleLetter }
            return item.ruleRange.contains(occurences.count)
        })
        print("PART 1")
        print(valid?.count)
        
        // Second Half
        print("SECOND HALF")
        
        let validSecond = passwords?.filter({ item -> Bool in
            
            let lowerOccurence = item.password[item.ruleRange.lowerBound - 1] == item.ruleLetter
            let upperOccurence = item.password[item.ruleRange.upperBound - 1] == item.ruleLetter
            
            return lowerOccurence != upperOccurence
        })
        
        print("PART 2")
        print(validSecond?.count)
    }
}
