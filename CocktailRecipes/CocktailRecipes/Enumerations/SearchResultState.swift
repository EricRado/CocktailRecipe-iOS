//
//  SearchResultState.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 6/20/21.
//  Copyright © 2021 Eric Rado. All rights reserved.
//

import Foundation

enum SearchResultState<T: DomainModel> {
    case notFiltered(models: T)
    case filtered(models: T)
    case error(message: String)
}
