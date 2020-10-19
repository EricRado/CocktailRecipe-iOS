//
//  DrinkListPresenter.swift
//  CocktailRecipes
//
//  Created by Jaison Vieira on 10/17/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import Foundation

struct DrinkListPresenter {
    private var drinks: [Drink]

    init(drinks: [Drink]) {
        self.drinks = drinks
    }

    func itemsCount() -> Int {
        return drinks.count
    }

    func itemForRow(_ row: Int) -> Drink {
        return drinks[row]
    }
}
