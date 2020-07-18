//
//  HTTPTask.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/18/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import Foundation

typealias Parameters = [String: String]

enum HTTPTask {
	case request
	case requestParameters(Parameters)
}
