//
//  HomeSection.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/23/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import Foundation

enum HomeSection: Int, CaseIterable {
	case random = 0
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
