//
//  IngredientSlimList.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 6/19/21.
//  Copyright © 2021 Eric Rado. All rights reserved.
//

import Foundation

struct IngredientSlim {
    let name: String
    
    init(dto: IngredientSlimDTO) {
        self.name = dto.name ?? ""
    }
}

extension IngredientSlim: DomainModel {}

struct IngredientSlimList {
    let ingredients: [IngredientSlim]
    
    init(dto: IngredientSlimListDTO) {
        self.ingredients = (dto.ingredients ?? []).map { IngredientSlim(dto: $0) }
    }
}

extension IngredientSlimList: DomainModel {}
