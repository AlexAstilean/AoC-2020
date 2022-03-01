//
//  Day16.swift
//  AoC2020
//
//  Created by Alex Astilean on 16/12/2020.
//

import Foundation

class Day16: Day {
    
    typealias Constraints = (range1: ClosedRange<Int>, range2: ClosedRange<Int>)
    var rules = [String: Constraints]()
    var fieldIds = [String: Int]()
    var myTicket = [Int]()
    var otherTickets = [[Int]]()
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay16", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let inputLines = string?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) else {
            return
        }
        
        parseTickets(lines: inputLines)
        
        let part1Result = otherTickets.flatMap { invalidFields(in: $0) }.reduce(0, +)
        print("Part 1 result: \(part1Result)")
        print("Part 2 result: \(part2())")
    }
    
    func parseTickets(lines: [String]) {
        
        var inputLines = lines
        while true {
            let line = inputLines.removeFirst()
            guard !line.isEmpty else { break }
            
            let lineComp = line.components(separatedBy: ": ")
            let rangeComp = lineComp[1].components(separatedBy: " or ")
            let rangeComp1 = rangeComp[0].components(separatedBy: "-")
            let rangeComp2 = rangeComp[1].components(separatedBy: "-")
            
            rules[lineComp[0]] = (range1: Int(rangeComp1[0])!...Int(rangeComp1[1])!, range2: Int(rangeComp2[0])!...Int(rangeComp2[1])!)
        }
        
        inputLines.removeFirst()
        myTicket = inputLines.removeFirst().components(separatedBy: ",").map { Int($0)! }
        
        inputLines.removeFirst(2)
        for line in inputLines {
            
            otherTickets += [line.components(separatedBy: ",").map { Int($0)! }]
        }
    }
    
    func isValid(field: Int, forConstraints c: Constraints) -> Bool {
        return ((field >= c.range1.lowerBound && field <= c.range1.upperBound) ||
                    (field >= c.range2.lowerBound && field <= c.range2.upperBound))
    }
    
    func isValid(field: Int) -> Bool {
        for (_, c) in rules {
            if isValid(field: field, forConstraints: c) {
                return true
            }
        }
        return false
    }
    
    func invalidFields(in ticket: [Int]) -> [Int] {
        
        return ticket.filter { !isValid(field: $0) }
    }
    
    func part2() -> Int {
        
        otherTickets.removeAll { !invalidFields(in: $0).isEmpty }
        otherTickets += [myTicket]
        
        let numberOfFields = myTicket.count
        var fieldIds = [Int:String]()
        var remainingRules = rules
        
        while fieldIds.count < numberOfFields {
            var anyChanges = false
            
            fieldIdLoop: for fieldId in 0..<numberOfFields where fieldIds[fieldId] == nil {
                var candidateRuleForField: String? = nil
                
                ruleLoop: for (ruleName, c) in remainingRules {
                    for ticket in otherTickets {
                        guard isValid(field: ticket[fieldId], forConstraints: c) else {
                            continue ruleLoop
                        }
                    }
                    
                    guard candidateRuleForField == nil else {
                        print("at least(!) two rules match for field \(fieldId): \(candidateRuleForField!), \(ruleName)")
                        continue fieldIdLoop
                    }
                    
                    candidateRuleForField = ruleName
                }
                
                guard let matchingRuleForField = candidateRuleForField else {
                    print("no rules match for field \(fieldId)")
                    return 0
                }
                
                fieldIds[fieldId] = matchingRuleForField
                remainingRules.removeValue(forKey: matchingRuleForField)
                anyChanges = true
            }
            
            guard anyChanges else {
                print("i'm stuck")
                return 0
            }
        }
        return fieldIds
            .filter { $0.1.hasPrefix("departure") }
            .map { myTicket[$0.0] }
            .reduce(1, *)
    }
}
