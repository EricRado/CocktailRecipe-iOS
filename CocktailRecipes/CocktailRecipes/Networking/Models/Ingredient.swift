//
//  Ingredient.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/19/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import Foundation

struct Ingredient: Decodable {
	let id: String
	let name: String
	let description: String
	let type: String

	private enum CodingKeys: String, CodingKey {
		case id = "idIngredient"
		case name = "strIngredient"
		case description = "strDescription"
		case type = "strType"
	}
}
