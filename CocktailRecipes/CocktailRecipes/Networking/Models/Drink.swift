//
//  Drink.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 6/20/21.
//  Copyright © 2021 Eric Rado. All rights reserved.
//

import Foundation

struct Drink {
    let id: String
    let name: String
    let category: String
    let iba: String?
    let alcoholic: String
    let glass: String
    let instructions: String
    let thumbURL: String?
    let ingredient1: String?
    let ingredient2: String?
    let ingredient3: String?
    let ingredient4: String?
    let ingredient5: String?
    let ingredient6: String?
    let ingredient7: String?
    let ingredient8: String?
    let measure1: String?
    let measure2: String?
    let measure3: String?
    let measure4: String?
    let measure5: String?
    let measure6: String?
    let measure7: String?
    let measure8: String?
    
    init(dto: DrinkDTO) {
        self.id = dto.id ?? ""
        self.name = dto.name ?? ""
        self.category = dto.category ?? ""
        self.iba = dto.iba ?? ""
        self.alcoholic = dto.alcoholic ?? ""
        self.glass = dto.glass ?? ""
        self.instructions = dto.instructions ?? ""
        self.thumbURL = dto.thumbURL
        self.ingredient1 = dto.ingredient1 ?? ""
        self.ingredient2 = dto.ingredient2 ?? ""
        self.ingredient3 = dto.ingredient3 ?? ""
        self.ingredient4 = dto.ingredient4 ?? ""
        self.ingredient5 = dto.ingredient5 ?? ""
        self.ingredient6 = dto.ingredient6 ?? ""
        self.ingredient7 = dto.ingredient7 ?? ""
        self.ingredient8 = dto.ingredient8 ?? ""
        self.measure1 = dto.measure1 ?? ""
        self.measure2 = dto.measure2 ?? ""
        self.measure3 = dto.measure3 ?? ""
        self.measure4 = dto.measure4 ?? ""
        self.measure5 = dto.measure5 ?? ""
        self.measure6 = dto.measure6 ?? ""
        self.measure7 = dto.measure7 ?? ""
        self.measure8 = dto.measure8 ?? ""
        
    }
}

extension Drink: DomainModel {}
