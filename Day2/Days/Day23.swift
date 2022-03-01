//
//  Day23.swift
//  Day2
//
//  Created by Alex Astilean on 23/12/2020.
//

import Foundation

class Day23: Day {
    
    let labeling  = "463528179"
    var cups = Set<Node>()
    
    func run() {
        
        var cups = labeling.map { Int(String($0))! }
        print("Part 1 Result: \(execute(cups: cups, repeats: 100).map {String($0)}.joined())")
        
        cups.append(contentsOf: Array(10...1_000_000) as [Int])
        print("Part 2 Result: \(part2b(cups: cups))")
    }
    
    func execute(cups: [Int], repeats: Int) -> [Int] {
        
        var cups = cups
        var currentCup = cups.first!
        
        for i in 1...repeats {
            if i % 1000 == 0 {
                print(i)
            }
            (currentCup, cups) = runMove(currentCup, cups)
        }
        
        let parts = cups.split(separator: 1)
        var result = [Int]()
        if parts.count > 1 {
            result = Array(parts[1] + parts[0])
        } else {
            result = Array(parts[0])
        }
        return result
    }
    
    func runMove(_ currentCup: Int, _ pCups: [Int]) -> (Int,[Int]) {
        
        var cups = pCups
        let index = cups.firstIndex(of: currentCup)!
        var pickUp = [Int]()
        var cupIndex = cups.startIndex
        if index < cups.endIndex - 1 {
            cupIndex = cups.index(index, offsetBy: 1)
        }
        for _ in 1...3 {
            let cup = cups.remove(at: cupIndex)
            pickUp.append(cup)
            if cupIndex >= cups.count {
                cupIndex = 0
            }
        }
        let nextCup = cups[cupIndex]
        var destination = currentCup - 1
        var destinationIndex = cups.firstIndex(of: destination)
        while destinationIndex == nil {
            destination -= 1
            if destination < cups.min()! {
                destination = cups.max()!
            }
            destinationIndex = cups.firstIndex(of: destination)
        }
        var insertIndex = cups.startIndex
        if destinationIndex! < cups.endIndex - 1 {
            insertIndex = cups.index(destinationIndex!, offsetBy: 1)
        }
        cups.insert(contentsOf: pickUp, at: insertIndex)
        return (nextCup, cups)
    }
    
    
    func part2b(cups: [Int]) -> Int {
        
        func insertCup(_ newCup: Int, afterCup: Int) {
            let oldNext = nextCup[afterCup]
            nextCup[afterCup] = newCup
            nextCup[newCup] = oldNext
        }
        func cupss(startingWith sc: Int, for max: Int? = nil) -> [Int] {
            var r = [sc]
            var i = sc
            while nextCup[i] != sc {
                guard max == nil || r.count < max! else { break }
                i = nextCup[i]
                r += [i]
            }
            return r
        }
        
        func removeCup(after ac: Int) -> Int {
            let toRemove = nextCup[ac]
            let newNext = nextCup[toRemove]
            nextCup[ac] = newNext
            return toRemove
        }
        let startingCups = cups
        
        var nextCup = Array(repeating: 0, count: 1_000_000 + 2)
        for (i, cup) in startingCups.enumerated() {
            nextCup[cup] = startingCups[(i + 1) % startingCups.count]
        }
        
        var currentCup = startingCups[0]
        
        for _ in 1...10_000_000 {
            
            let pickUp = (0..<3).map { _ in removeCup(after: currentCup) }
            
            var destination = currentCup - 1
            while pickUp.contains(destination) || destination < 1 {
                destination -= 1
                if destination < 1 {
                    destination = 1_000_000
                }
            }
            
            pickUp.reversed().forEach { insertCup($0, afterCup: destination) }
            
            currentCup = nextCup[currentCup]
        }
        
        let starCups = cupss(startingWith: 1, for: 3)
        return starCups.dropFirst().reduce(1, *)
    }
}

extension Day23 {
    func part2c() {
        
        var cupsInt = labeling.map { Int(String($0))! }
        cupsInt.append(contentsOf: Array(10...1_000_000) as [Int])
        var originHead = createLinkedList(cupsInt: cupsInt)
        
        for i in 0...10_000_000 {
            print(i)
            let first = originHead.next!
            let second = first.next!
            let third = second.next!
            
            let toMove = [first, second, third]
            let next = third.next!
            
            originHead.next = next
            cups.subtract(toMove)
            
            let dest = cups.filter { $0.data < originHead.data }.max(by: { $0.data < $1.data }) ?? cups.max(by: { $0.data < $1.data })!
            let after = dest.next
            
            dest.next = toMove[0]
            toMove[2].next = after
            
            cups.formUnion(toMove)
            originHead = next
        }
        
        let one = cups.filter { $0.data <= 1 }.max(by: { $0.data < $1.data })
        print(one)
    }
    
    func createLinkedList(cupsInt: [Int]) -> Node {
        
        let head = Node(data: cupsInt.first!)
        var prev = head
        cups.insert(head)
        for i in 1..<cupsInt.count {
            let next = Node(data: cupsInt[i])
            cups.insert(next)
            prev.next = next
            prev = next
        }
        prev.next = head
        return head
    }
    
    class Node: Hashable, Equatable {
        
        static func == (lhs: Day23.Node, rhs: Day23.Node) -> Bool {
            lhs.data == rhs.data
        }
        
        var data: Int
        var next: Node?
        
        init(data: Int) {
            self.data = data
        }
        
        func compare(to other: Node) -> Int {
            return data
        }
        
        var hashValue: Int {
            return data.hashValue
        }
    }
}
