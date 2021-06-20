//
//  HomePresenter.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/21/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import Foundation

protocol HomeViewDelegate: AnyObject {
	func reloadCollectionView(for section: Int)
}

final class HomePresenter {
	weak var delegate: HomeViewDelegate?
    private let drinkRepo: DrinkRepo
	private lazy var fetchPopularDrinksCompletion: (Result<[Drink], Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case .success(let drinks):
			self.popularDrinks = drinks
            let sectionIndex = HomeSection.popular.rawValue
			DispatchQueue.main.async {
				self.delegate?.reloadCollectionView(for: sectionIndex)
			}
		case .failure(let error):
			print(error.localizedDescription)
		}
	}

	private lazy var fetchLatestDrinksCompletion: (Result<[Drink], Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case .success(let drinks):
			self.latestDrinks = drinks
            let sectionIndex = HomeSection.latest.rawValue
			DispatchQueue.main.async {
				self.delegate?.reloadCollectionView(for: sectionIndex)
			}
		case .failure(let error):
			print(error.localizedDescription)
		}
	}

	private lazy var fetchRandomDrinksCompletion: (Result<[Drink], Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case .success(let drinks):
			self.randomDrinks = drinks
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
		self.drinkRepo = DrinkRepo(networkManager: networkManager)
		fetchPopularDrinks()
		fetchLatestDrinks()
		fetchRandomDrinks()
	}

	private func fetchPopularDrinks() {
        drinkRepo.fetchDrinks(by: .popular, completion: fetchPopularDrinksCompletion)
	}

	private func fetchLatestDrinks() {
        drinkRepo.fetchDrinks(by: .latest, completion: fetchLatestDrinksCompletion)
	}

	private func fetchRandomDrinks() {
        drinkRepo.fetchDrinks(by: .random, completion: fetchRandomDrinksCompletion)
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
