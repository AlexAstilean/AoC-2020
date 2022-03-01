//
//  Day19.swift
//  AoC2020
//
//  Created by Alex Astilean on 22/12/2020.
//

import Foundation

class Day19: Day {
    
    var resolvedRules = [Int:[String]](minimumCapacity: 500)
    var unresolvedRules = [Int:String](minimumCapacity: 500)
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay19", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let inputLines = string?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) else {
            return
        }
        
        let groups = inputLines.split(whereSeparator: { $0.isEmpty })
        let rules = Array(groups[0])
        let messages = Array(groups[1])
        
        // Part 1
        parse(rules: rules)
        let validStringsForRule0 = Set(resolveRule(0))
        
        let validMessages = validStringsForRule0.intersection(messages)
        print("Part 1 Result: \(validMessages.count)")
        
        
        // Part 2
        
        parse(rules: rules)
        // rule 0 (see below) = "8 11"
        unresolvedRules[8] = "42 | 42 8"
        unresolvedRules[11] = "42 31 | 42 11 31"

        //
        // we will assume that rule 0 is always "8 11" -- this is true for
        // the actual input and for the part2 test input, but not for the
        // part1 test input!
        //
        // therefore, any valid string consists exclusively of 1+ occurances
        // of rule 42, followed by 1+ occurrances of rule 31,
        // i.e. must match ^(42)+(31)+$, so to speak.
        //
        // additionally, the rules dictate that there must be more
        // prefixes(rule42) than there are suffixes(rule31), because rule 11
        // always has an equal amount of both of those.
        //
        // also note that all valid strings per rule have the same length,
        // as they are all combinations of different lengths.
        // further, both rules 31 and 42 are of length (test=5, puzzle=8).
        //

        let validStringsRule31 = resolveRule(31)
        let validStringsRule42 = resolveRule(42)

        var validCount = 0
        for message in messages {
            var remainingMessage = message

            let suffixesMatched = trim(anyOf: validStringsRule31, from: &remainingMessage, fromStart: false)
            guard suffixesMatched > 0 else { continue }

            let prefixesMatched = trim(anyOf: validStringsRule42, from: &remainingMessage, fromStart: true)
            guard prefixesMatched > suffixesMatched else { continue }

            guard remainingMessage.isEmpty else { continue } // message must have no other parts in the middle

            validCount += 1
        }
        print("Part 2 Result: \(validCount)")

    }
    
    func parse(rules: [String]) {
        for rule in rules {
            let parts = rule.components(separatedBy: ": ")
            let ruleId = Int(parts[0])!
            
            if !parts[1].hasPrefix("\"") {
                unresolvedRules[ruleId] = parts[1]
            } else {
                // final rule, i.e. already resolved
                resolvedRules[ruleId] = [parts[1].filter { $0 != "\"" }]
            }
        }
    }
    
    func resolveRule(_ ruleId: Int, depth: Int = 0) -> [String] {
        if let validStrings = resolvedRules[ruleId] {
            return validStrings
        }
        
        var validStrings = [String]()
        
        let subRules = unresolvedRules[ruleId]!.components(separatedBy: " | ")
        for subRule in subRules {
            var validStringsForSubRule = [String]()
            
            let otherRuleIds = subRule.components(separatedBy: " ").map { Int($0)! }
            for otherRuleId in otherRuleIds {
                let otherStrings = resolveRule(otherRuleId, depth: depth + 1)
                
                guard !validStringsForSubRule.isEmpty else {
                    validStringsForSubRule = otherStrings
                    continue
                }
                
                var newVSFSR = [String]()
                for os in otherStrings {
                    for vsfr in validStringsForSubRule {
                        newVSFSR += [vsfr + os]
                    }
                }
                validStringsForSubRule = newVSFSR
            }
            
            validStrings += validStringsForSubRule
        }
        
        resolvedRules[ruleId] = validStrings
        return validStrings
    }
    
    func trim(anyOf matches: [String], from string: inout String, fromStart: Bool) -> Int {
            var matchCount = 0
            outer: while true {
                for match in matches {
                    if fromStart && string.hasPrefix(match) {
                        string.removeFirst(match.count)
                        matchCount += 1
                        continue outer
                    } else if !fromStart && string.hasSuffix(match) {
                        string.removeLast(match.count)
                        matchCount += 1
                        continue outer
                    }
                }
                break
            }

            return matchCount
        }
}
