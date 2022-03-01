//
//  Day20.swift
//  AoC2020
//
//  Created by Alex Astilean on 20/12/2020.
//

import Foundation

class Day20: Day {
    
    struct Tile {
        
        let id: Int
        let imageData: [String]
        var borders: [String] {
            var list = [String]()
            list.append(imageData.first!)
            list.append(String(imageData.last!))
            list.append(String(imageData.map { $0.first! }))
            list.append(String(imageData.map { $0.last! }))
            return list
        }
        
        var flippedVert: Tile {
            return Tile(id: self.id, imageData: imageData.reversed() as [String])
        }
        var flippedHoriz: Tile {
            return Tile(id: self.id, imageData: imageData.map { String($0.reversed()) })
        }
        
        var allPossibleBorders: [String] {
            var list = [String]()
            list.append(contentsOf: borders)
            list.append(contentsOf: borders.map { String($0.reversed()) })
            return list
        }
    }
    
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay20", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        let lines = string?.components(separatedBy: .newlines).filter { !$0.isEmpty } ?? []
        var tiles = [Tile]()
        var currentTitleId = -1
        var currentImageData = [String]()
        for line in lines {
            if line.contains("Tile") {
                if currentTitleId != -1 {
                    tiles.append(Tile(id: currentTitleId, imageData: currentImageData))
                }
                currentTitleId = Int(line.components(separatedBy: "Tile ")[1].dropLast())!
                currentImageData = [String]()
            } else {
                currentImageData.append(line)
            }
        }
        tiles.append(Tile(id: currentTitleId, imageData: currentImageData))
        
        print(tiles.count)
        
        var cornerTiles = [Tile]()
        var i = 0
        while i < tiles.count {
            let tile = tiles[i]
            if day20CuntBordersMatched(tile, tiles: tiles) == 2 {
                cornerTiles.append(tile)
            }
            i += 1
        }
        
        print(cornerTiles.count)
        print("PART 1 result: \(cornerTiles.map { $0.id }.reduce(1, *))")
    }
    
    func day20CuntBordersMatched(_ tile: Tile, tiles: [Tile]) -> Int {
        
        var matchingBorders = 0
        borders: for border in tile.borders {
            for j in 0..<tiles.count {
                let cTile = tiles[j]
                if cTile.id != tile.id {
                    if cTile.allPossibleBorders.contains(border) {
                        matchingBorders += 1
                        continue borders
                    }
                }
            }
        }
        return matchingBorders
    }
}
