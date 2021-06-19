//
//  IngredientSlimListDTO.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 6/19/21.
//  Copyright © 2021 Eric Rado. All rights reserved.
//

import Foundation

struct IngredientSlimDTO: Decodable {
    let name: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "strIngredient1"
    }
}

struct IngredientSlimListDTO: Decodable {
    let ingredients: [IngredientSlimDTO]?
    
    private enum CodingKeys: String, CodingKey {
        case ingredients = "drinks"
    }
}
