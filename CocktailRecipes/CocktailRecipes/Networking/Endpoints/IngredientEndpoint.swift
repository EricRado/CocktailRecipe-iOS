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
}

extension IngredientEndpoint: EndpointConstructable {
	var path: String {
		switch self {
		case .search:
			return "search.php"
		}
	}

	var httpMethod: HTTPMethod {
		switch self {
		case .search:
			return .get
		}
	}

	var httpTask: HTTPTask {
		switch self {
		case .search(let name):
			return .requestParameters(["i": name])
		}
	}

}
