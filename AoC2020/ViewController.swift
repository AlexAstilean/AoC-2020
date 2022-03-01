//
//  ViewController.swift
//  AoC2020
//
//  Created by Alex Astilean on 02/12/2020.
//

import Cocoa

enum Days {
    case day1
    case day2
    case day3
    case day4
    case day5
    case day6
    case day7
    case day8
    case day9
    case day10
    case day11
    case day12
    case day13
    case day14
    case day15
    case day16
    case day17
    case day18
    case day19
    case day20
    case day21
    case day22
}

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let day: Day = Day6()
        
        day.run()
    }
}

extension StringProtocol {
    
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
