//
//  DrinkSection.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/23/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import Foundation

enum HomeSectionType {
	case random
	case latest
	case popular

	var title: String {
		switch self {
		case .random:
			return "Try These Drinks"
		case .latest:
			return "Latest"
		case .popular:
			return "Popular"
		}
	}

}

struct DrinkSection {
	let title: String
	let sectionType: HomeSectionType
}
