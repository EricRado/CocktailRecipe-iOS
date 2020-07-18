//
//  IngredientEndpoint.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/18/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import Foundation

enum IngredientEndpoint {
	case search(name: String)
	case thumbnail(name: String)
}
