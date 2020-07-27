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

	// MARK:- Data Sources
	private var randomDrinks: [Drink] = []
	private var latestDrinks: [Drink] = []
	private var popularDrinks: [Drink] = []

	private lazy var sections: [DrinkSection] = {
		return [
			DrinkSection(title: HomeSectionType.random.title, sectionType: .random),
			DrinkSection(title: HomeSectionType.latest.title, sectionType: .latest),
			DrinkSection(title: HomeSectionType.popular.title, sectionType: .popular)
		]
	}()

	var sectionCount: Int {
		return sections.count
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

	func sectionType(for sectionIndex: Int) -> HomeSectionType {
		return sections[sectionIndex].sectionType
	}

	func title(for sectionIndex: Int) -> String {
		return sections[sectionIndex].title
	}

	func dataSource(for sectionType: HomeSectionType) -> [Drink] {
		switch sectionType {
		case .random:
			return randomDrinks
		case .latest:
			return latestDrinks
		case .popular:
			return popularDrinks
		}
	}
}
