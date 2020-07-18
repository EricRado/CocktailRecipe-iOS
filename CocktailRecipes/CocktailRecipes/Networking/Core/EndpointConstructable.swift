//
//  EndpointConstructable.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/18/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import Foundation

protocol EndpointConstructable {
	var path: String { get }
	var httpMethod: HTTPMethod { get }
	var httpTask: HTTPTask { get }
}

extension EndpointConstructable {
	var baseURL: String {
		return "https://www.thecocktaildb.com/api/json/v2"
	}
}
