//
//  Day14.swift
//  Day2
//
//  Created by Alex Astilean on 13/12/2020.
//

import Foundation

class Day14: Day {
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay14", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let lines = string?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) else {
            return
        }
        print("PART 1 Result: \(part1(lines: lines))")
        print("PART 2 Result: \(part2(lines: lines))")
    }
    
    func part1(lines: [String]) -> Int {
        var mem: [Int: Int] = [:]
        var mask: [Character?] = []
        for line in lines {
            if String(line.prefix(7)) == "mask = " {
                let index = line.index(line.startIndex, offsetBy: 7)
                mask = line.suffix(from: index).map { ($0 == "X") ? nil : $0 }
            } else {
                let regex = try! NSRegularExpression(pattern: "^mem\\[(\\d+)\\] = (\\d+)$", options: [])
                let matches = regex.matches(in: String(line), options: [], range: NSMakeRange(0, line.count))
                let address = (String(line) as NSString).substring(with: matches[0].range(at: 1))
                let value = (String(line) as NSString).substring(with: matches[0].range(at: 2))
                mem[Int(address)!] = day14Masked(value: Int(value)!, mask: mask)
            }
        }
        
        return mem.values.reduce(0, +)
    }
    
    func day14Masked(value: Int, mask: [Character?]) -> Int {
        var binary = String(value, radix: 2)
        binary = String(repeating: "0", count: mask.count - binary.count) + binary
        var masked: [Character] = []
        for (index, char) in binary.enumerated() {
            masked.append((mask[index] != nil) ? mask[index]! : char)
        }
        return Int(String(masked), radix: 2)!
    }
}

extension Day14 {
    
    func part2(lines: [String]) -> Int {
        
        var lines = lines
        var memory = [Int:Int]()
        var mask = [Character]()
        
        while !lines.isEmpty {
            var foo = lines.removeFirst()
            
            guard !foo.hasPrefix("mask") else {
                // done, next prefix
                foo.removeFirst("mask = ".count)
                mask = Array(foo)
                continue
            }
            
            let c = foo.components(separatedBy: " ")
            var addressString = c[0]
            let value = Int(c[2])!
            
            addressString.removeFirst("mem[".count)
            addressString.removeLast("]".count)
            var address = Int(addressString)!
            
            for i in 0..<36 {
                let bit = 35 - i
                switch mask[i] {
                case "X":
                    break // no change yet (floating, handled below)
                case "0":
                    break // no change at all
                case "1":
                    address |= (1 << bit)
                default:
                    print("ERROR - invalid mask: \(mask)")
                    return 0
                }
            }
            
            var newMask = mask
            for i in 0..<36 where newMask[i] != "X" {
                let bit = 35 - i
                newMask[i] =  address & (1<<bit) > 0 ? "1" : "0"
            }
            
            let al = addressList(fromMask: newMask)
            al.forEach {
                memory[$0] = value
            }
            
        }
        
        return memory.values.reduce(0, +)
    }
    
    func addressList(fromMask mask: [Character]) -> [Int] {
            var r = [Int]()

            guard let x = mask.firstIndex(of: "X") else {
                var n = 0
                for i in 0..<36 where mask[i] == "1" {
                    let bit = 35 - i
                    n |= (1 << bit)
                }

                return [n]
            }

            var newMask = mask
            newMask[x] = "0"
            r += addressList(fromMask: newMask)

            newMask[x] = "1"
            r += addressList(fromMask: newMask)

            return r
        }
}
