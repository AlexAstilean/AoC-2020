//
//  Day21.swift
//  Day2
//
//  Created by Alex Astilean on 21/12/2020.
//

import Foundation

class Day21: Day {
    
    struct Food: Hashable {
        var ingredients: [String]
        var allergens: [String]
    }
    
    func run() {
        
        let path = Bundle.main.path(forResource: "inputDay21", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        guard let inputLines = string?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) else {
            return
        }
        
        var allFoods = [Food]()
        var allergenIngredient = [String: String]()
        
        for line in inputLines {
            
            var parts = line.components(separatedBy: " (contains ")
            parts[1].removeLast()
            
            let ingredients = parts[0].components(separatedBy: " ")
            let allergens = parts[1].components(separatedBy: ", ")
            
            allFoods += [Food(ingredients: ingredients, allergens: allergens)]
        }
        
        var allAllergens = Set(allFoods.flatMap { $0.allergens })
        
        while !allAllergens.isEmpty {
            
            for allergen in allAllergens {
                var ingredients = Set<String>()
                
                for food in allFoods where food.allergens.contains(allergen) {
                    ingredients = ingredients.isEmpty ? Set(food.ingredients) : ingredients.intersection(food.ingredients)
                    
                    guard ingredients.count != 1 else {
                        let match = ingredients.first
                        allAllergens.remove(allergen)
                        allergenIngredient[allergen] = match
                        
                        for i in 0..<allFoods.count {
                            allFoods[i].ingredients.removeAll { $0 == match }
                        }
                        break
                    }
                }
            }
        }
        
        let remainingIngredients = allFoods.flatMap { $0.ingredients }
        print("Part 1 result: \(remainingIngredients.count)")
        
        let allergenIngredients = allergenIngredient.sorted(by: { $0.key < $1.key }).map { $0.value}.joined(separator: ",")
        print("Part 2 result: \(allergenIngredients)")
    }
}
