//
//  HomePresenter.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/21/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import Foundation

protocol HomeViewDelegate: class {
	func displayPopularDrinks(_ drinks: [Drink])
	func displayLatestDrinks()
	func displayRandomDrinks()
}

final class HomePresenter {
	weak var delegate: HomeViewDelegate?
	private let networkManager: NetworkManager
	private lazy var fetchPopularDrinksCompletion: (Result<DrinkResponse, Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case.success(let drinkResponse):
			print(drinkResponse)
			DispatchQueue.main.async {
				self.delegate?.displayPopularDrinks(drinkResponse.drinks)
			}
		case .failure(let error):
			print(error.localizedDescription)
		}
	}

	private lazy var fetchLatestDrinksCompletion: (Result<DrinkResponse, Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case .success(let drinkResponse):
			print(drinkResponse)
		case .failure(let error):
			print(error.localizedDescription)
		}
	}

	private lazy var fetchRandomDrinksCompletion: (Result<DrinkResponse, Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case .success(let drinkResponse):
			print(drinkResponse)
		case .failure(let error):
			print(error.localizedDescription)
		}
	}

	init(networkManager: NetworkManager) {
		self.networkManager = networkManager
		fetchPopularDrinks()
		fetchLatestDrinks()
		fetchRandomDrinks()
	}

	private func fetchPopularDrinks() {
		networkManager.request(CocktailEndpoint.popular, completion: fetchPopularDrinksCompletion)
	}

	private func fetchLatestDrinks() {
		networkManager.request(CocktailEndpoint.latest, completion: fetchLatestDrinksCompletion)
	}

	private func fetchRandomDrinks() {
		networkManager.request(CocktailEndpoint.random, completion: fetchRandomDrinksCompletion)
	}
}
