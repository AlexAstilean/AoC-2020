//
//  Day8.swift
//  Day2
//
//  Created by Alex Astilean on 08/12/2020.
//

import Foundation

class Day8: Day {
    
    enum Operation: String {
        case nop, acc, jmp
    }
    enum Sign: String {
        case plus = "+"
        case minus = "-"
    }
    
    class Instruction: CustomStringConvertible {
        var description: String {
            "\(operation) - \(sign)\(value)"
        }
        
        
        let operation: Operation
        let value: Int
        let sign: Sign
        var ran: Bool
        
        
        init(operation: Operation, value: Int, sign: Sign) {
            self.operation = operation
            self.value = value
            self.sign = sign
            self.ran = false
        }
        
        func compute(value: Int) -> Int {
            
            switch sign {
            case .minus:
                return value - self.value
            case .plus:
                return value + self.value
            }
        }
        
        
    }
    
    func run() {
        let path = Bundle.main.path(forResource: "inputDay8", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let lines = string?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) else {
            return
        }
        
        let instructions = lines.compactMap { line -> Instruction? in
            
            let instructionString = line.components(separatedBy: .whitespaces)
            
            guard let operation = Operation(rawValue: instructionString[0]),
                  let value = Int(instructionString[1].dropFirst()) else {
                print("FAIL")
                return nil
            }
            let sign: Sign
            if instructionString[1].first == "+" {
                sign = .plus
            } else if instructionString[1].first == "-" {
                sign = .minus
            } else {
                print("FAIL sign")
                return nil
            }
            return Instruction(operation: operation, value: value, sign: sign)
            
        }
        
        day8RunInstruction(line: 0, acc: 0, set: instructions)
        
        
        print("PART 2")
        for (index, instruction) in instructions.enumerated() {
            
            if instruction.operation == .jmp {
                
                print("Replacing \(instruction)")
                var newSet = instructions
                newSet[index] = Instruction(operation: .nop,
                                            value: instruction.value,
                                            sign: instruction.sign)
                day8RunInstruction(line: 0, acc: 0, set: newSet)
            } else if instruction.operation == .nop {
                print("Replacing \(instruction)")
                var newSet = instructions
                newSet[index] = Instruction(operation: .jmp,
                                            value: instruction.value,
                                            sign: instruction.sign)
                day8RunInstruction(line: 0, acc: 0, set: newSet)
            } else {
                continue
            }
        }
    }
    
    func day8RunInstruction(line: Int, acc: Int, set: [Instruction]) {
        
        if line == set.indices.upperBound {
            print("------      FINISHED - \(acc)")
            return
        }
        let instruction = set[line]
        if instruction.ran {
            
            print("Stopping - \(acc)")
            set.forEach { $0.ran = false }
            return
        }
        instruction.ran = true
        switch instruction.operation {
        case .nop:
            day8RunInstruction(line: line + 1, acc: acc, set: set)
        case .acc:
            day8RunInstruction(line: line + 1, acc: instruction.compute(value: acc), set: set)
        case .jmp:
            day8RunInstruction(line: instruction.compute(value: line), acc: acc, set: set)
        }
    }
}
