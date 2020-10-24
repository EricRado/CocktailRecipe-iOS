//
//  HomePresenter.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/21/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import Foundation

protocol HomeViewDelegate: class {
	func reloadCollectionView(for section: Int)
}

final class HomePresenter {
	weak var delegate: HomeViewDelegate?
	private let networkManager: NetworkManager
	private lazy var fetchPopularDrinksCompletion: (Result<DrinkResponse, Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case .success(let drinkResponse):
			self.popularDrinks = drinkResponse.drinks
            let sectionIndex = HomeSection.popular.rawValue
			DispatchQueue.main.async {
				self.delegate?.reloadCollectionView(for: sectionIndex)
			}
		case .failure(let error):
			print(error.localizedDescription)
		}
	}

	private lazy var fetchLatestDrinksCompletion: (Result<DrinkResponse, Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case .success(let drinkResponse):
			self.latestDrinks = drinkResponse.drinks
            let sectionIndex = HomeSection.latest.rawValue
			DispatchQueue.main.async {
				self.delegate?.reloadCollectionView(for: sectionIndex)
			}
		case .failure(let error):
			print(error.localizedDescription)
		}
	}

	private lazy var fetchRandomDrinksCompletion: (Result<DrinkResponse, Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case .success(let drinkResponse):
			self.randomDrinks = drinkResponse.drinks
            let sectionIndex = HomeSection.random.rawValue
			DispatchQueue.main.async {
				self.delegate?.reloadCollectionView(for: sectionIndex)
			}
		case .failure(let error):
			print(error.localizedDescription)
		}
	}

	// MARK: - Data Sources
	private var randomDrinks: [Drink] = []
	private var latestDrinks: [Drink] = []
	private var popularDrinks: [Drink] = []

	var sectionCount: Int {
        return HomeSection.allCases.count
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

	func sectionType(for sectionIndex: Int) -> HomeSection {
		return HomeSection.allCases[sectionIndex]
	}

	func title(for sectionIndex: Int) -> String {
        return HomeSection.allCases[sectionIndex].title
	}

	func dataSource(for sectionType: HomeSection) -> [Drink] {
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
