//
//  CocktailEndpoints.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/18/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import Foundation

enum CocktailEndpoint {
	case popular
	case latest
	case random
	case search(name: String)
	case search(id: String)
	case search(ingredient: String)
	case firstLetter(letter: String)
	case thumbnail(name: String)
}
