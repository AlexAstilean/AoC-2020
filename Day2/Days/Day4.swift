//
//  Day4.swift
//  Day2
//
//  Created by Alex Astilean on 04/12/2020.
//

import Foundation

class Day4: Day {
    
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay4", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let stringPass = string?.components(separatedBy: "\n\n") else { return}
        
        let stringPassports = stringPass.compactMap { item -> [String: String]? in
            
            let components = item.components(separatedBy: .whitespacesAndNewlines)
            let result = components.reduce([String: String]()) { result, item -> [String: String]? in
                var res = result
                let comp = item.components(separatedBy: ":")
                guard comp.count == 2 else {
                    return res
                    
                }
                res?[comp[0]] = comp[1]
                return res
            }
            
//            if result?["iyr"] != nil,
//            result?["eyr"] != nil,
//            result?["hgt"] != nil,
//            result?["hcl"] != nil,
//            result?["ecl"] != nil,
//            result?["pid"] != nil,
//            result?["byr"] != nil {
//
//                print(result?.keys)
//                return result
//            } else {
//                return nil
//            }

            if let byr = Int(result?["byr"] ?? "0"), 1920...2002 ~= byr,
                let iyr = Int(result?["iyr"] ?? "0"), 2010...2020 ~= iyr,
                let eyr = Int(result?["eyr"] ?? "0"), 2020...2030 ~= eyr,
                let hgt = result?["hgt"],
                let hcl = result?["hcl"], hcl.first == "#",
                let ecl = result?["ecl"], ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(ecl),
                let pid = result?["pid"], pid.count == 9, pid.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil {
                
                let hcll = hcl.suffix(hcl.count - 1)
                guard hcll.count == 6,
                        hcll.range(of: "^[a-f0-9]+$", options: .regularExpression) != nil else {
                    return nil
                    
                }
                
                let hgtMeasure = hgt.suffix(2)
                if hgtMeasure == "cm" {
                    guard let value = Int(hgt.prefix(3)), 150...193 ~= value else {
                        return nil
                    }
                    
                } else if hgtMeasure == "in" {
                    guard let value = Int(hgt.prefix(2)), 59...76 ~= value else {
                        return nil }
                } else {
                    return nil
                }
                return result
                    
            } else {
                return nil
            }
        }
        
        print(stringPassports.count)
    }
}
