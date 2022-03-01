//
//  Day6.swift
//  AoC2020
//
//  Created by Alex Astilean on 06/12/2020.
//

import Foundation
import Algorithms

class Day6: Day {
    
    func run() {

        let path = Bundle.main.path(forResource: "inputDay6", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        guard let groups = string?.components(separatedBy: "\n\n") else { return}

        var groupsYes = [Int]()

        // Part 1 / Anyone answered YES
        for group in groups {

            var characters = Set(group)
            characters.remove("\n")
            groupsYes.append(characters.count)
        }

        print("Sum is: \(groupsYes.reduce(0, +))")


        // Part 2 / Everyone answered yes

        groupsYes = []

        for group in groups {

            let characters = group.components(separatedBy: .newlines).compactMap { return $0.isEmpty ? nil: $0 }

            var common = [Character]()

            for char in characters[0] {

                if characters.filter({ $0.contains(char) }).count == characters.count {
                    common.append(char)
                }
            }
            groupsYes.append(common.count)
        }
        print("Sum2 is: \(groupsYes.reduce(0, +))")
    }
}
