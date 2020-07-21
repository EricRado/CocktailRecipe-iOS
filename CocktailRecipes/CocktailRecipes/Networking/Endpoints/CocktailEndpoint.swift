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
	case searchWithId(String)
	case searchWithName(String)
	case searchWithIngredient(String)
	case firstLetter(letter: String)
}

extension CocktailEndpoint: EndpointConstructable {
	var path: String {
		switch self {
		case .popular:
			return "popular.php"
		case .latest:
			return "latest.php"
		case .random:
			return "randomselection.php"
		case .searchWithId:
			return "lookup.php"
		case .searchWithName, .firstLetter:
			return "search.php"
		case .searchWithIngredient:
			return "filter.php"
		}
	}

	var httpMethod: HTTPMethod {
		switch self {
		case .popular, .latest, .random, .searchWithId, .searchWithName,
			 .searchWithIngredient, .firstLetter:
			return .get
		}
	}

	var httpTask: HTTPTask {
		switch self {
		case .popular, .latest, .random:
			return .request
		case .searchWithId(let id):
			return .requestParameters(["i": id])
		case .searchWithName(let name):
			return .requestParameters(["s": name])
		case .searchWithIngredient(let ingredientName):
			return .requestParameters(["i": ingredientName])
		case .firstLetter(let letter):
			return .requestParameters(["f": letter])
		}
	}
}
