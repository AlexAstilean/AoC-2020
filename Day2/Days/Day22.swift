//
//  Day22.swift
//  Day2
//
//  Created by Alex Astilean on 22/12/2020.
//

import Foundation

class Day22: Day {
  
  func run() {
    
    let path = Bundle.main.path(forResource: "inputDay22", ofType: "txt")
    let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
    
    guard let inputLines = string?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) else {
      return
    }
    var playerCards = [[Int]]()
    
    var player = 0
    playerCards += [[Int]()]
    for line in inputLines {
      guard !line.hasPrefix("Player 2") else {
        playerCards += [[Int]()]
        player += 1
        continue
      }
      
      guard let i = Int(line) else { continue }
      playerCards[player] += [i]
    }
    
    print("Part 1 Result: \(playPart1(playerCards: playerCards))")
    print("Part 2 Result: \(playPart2(pc: playerCards))")

  }
  
  func playPart1(playerCards: [[Int]]) -> Int {
    
    var cards = playerCards
    
    while !cards[0].isEmpty && !cards[1].isEmpty {
      
      let drawnCards = [cards[0].removeFirst(), cards[1].removeFirst()]
      
      if drawnCards[0] > drawnCards[1] {
        cards[0] += [drawnCards[0], drawnCards[1]]
      } else {
        cards[1] += [drawnCards[1], drawnCards[0]]
      }
    }
    let winningCards = cards[0].isEmpty ? cards[1] : cards[0]
    var score = 0
    for (i, card) in winningCards.reversed().enumerated() {
      score += card*(i+1)
    }
    return score
  }
  
  func playPart2(pc: [[Int]], depth: Int = 0) -> Int {
    
    var cards = pc
    var deckHistory = [[[Int]]]() // deckHistory[player][round] = [cards]
    deckHistory += [[[Int]]()] // player0
    deckHistory += [[[Int]]()] // player1
    var round = 0
    
    while !cards[0].isEmpty && !cards[1].isEmpty {
      round += 1
      
      // Before either player deals a card, if there was a previous round in this
      // game that had exactly the same cards in the same order in the same
      // players' decks, the game instantly ends in a win for player 1.
      var looped = [false, false]
      for dhPlayer in [0, 1] {
        for dhRound in deckHistory[dhPlayer] {
          if dhRound == cards[dhPlayer] {
            looped[dhPlayer] = true
          }
        }
      }
      
      guard !looped[0] && !looped[1] else {
        return 0
      }
      
      deckHistory[0] += [cards[0]]
      deckHistory[1] += [cards[1]]
      
      let drawnCards = [cards[0].removeFirst(), cards[1].removeFirst()]
      var winner: Int
      
      // If both players have at least as many cards remaining in their deck as
      // the value of the card they just drew, the winner of the round is
      // determined by playing a new game of Recursive Combat
      if cards[0].count >= drawnCards[0] && cards[1].count >= drawnCards[1] {
        var recursivePlayerCards = cards
        recursivePlayerCards[0].removeLast(recursivePlayerCards[0].count - drawnCards[0])
        recursivePlayerCards[1].removeLast(recursivePlayerCards[1].count - drawnCards[1])
        winner = playPart2(pc: recursivePlayerCards, depth: depth + 1)
      } else {
        winner = (drawnCards[0] > drawnCards[1]) ? 0 : 1
      }
      
      if winner == 0 {
        cards[0] += [drawnCards[0], drawnCards[1]]
      } else {
        cards[1] += [drawnCards[1], drawnCards[0]]
      }
    }
    guard depth == 0 else {
          // this is a sub-game, return winning player id
          return cards[0].isEmpty ? 1 : 0
        }

        // top-level game, return score
        let winningCards = cards[0].isEmpty ? cards[1] : cards[0]
        var score = 0
        for (i, card) in winningCards.reversed().enumerated() {
          score += card*(i+1)
        }

        return score
  }
}
