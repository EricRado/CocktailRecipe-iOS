//
//  Ingredient.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 6/20/21.
//  Copyright © 2021 Eric Rado. All rights reserved.
//

import Foundation

struct Ingredient {
    let id: String
    let name: String
    let description: String
    let type: String

    init(dto: IngredientDTO) {
        self.id = dto.id ?? ""
        self.name = dto.name ?? ""
        self.description = dto.description ?? ""
        self.type = dto.type ?? ""
    }
}

extension Ingredient: DomainModel {}
