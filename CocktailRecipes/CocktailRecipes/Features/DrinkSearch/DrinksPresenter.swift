//
//  DrinksPresenter.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 10/14/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import Foundation

protocol DrinksPresenterDelegate: AnyObject {
	func reloadCollectionView()
}

final class DrinksPresenter {
	weak var delegate: DrinksPresenterDelegate?
    private let drinkRepo: DrinkRepo
	private var nonFilteredDrinks: [Drink]?
	private(set) var searchResultState: SearchResultState<[Drink]> = .notFiltered(models: [])

	private lazy var fetchDrinksFilteredCompletionHandler: (Result<[Drink], Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case .success(let drinks):
			self.searchResultState = .filtered(models: drinks)
			DispatchQueue.main.async {
				self.delegate?.reloadCollectionView()
			}
		case .failure(let error):
			self.searchResultState = .error(message: error.localizedDescription)
			DispatchQueue.main.async {
				self.delegate?.reloadCollectionView()
			}
		}
	}

	private lazy var fetchDrinksCompletionHandler: (Result<[Drink], Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case .success(let drinks):
			self.nonFilteredDrinks = drinks
			self.searchResultState = .notFiltered(models: self.nonFilteredDrinks ?? [])
			DispatchQueue.main.async {
				self.delegate?.reloadCollectionView()
			}
		case .failure(let error):
			self.searchResultState = .error(message: error.localizedDescription)
			DispatchQueue.main.async {
				self.delegate?.reloadCollectionView()
			}
		}
	}

	init(networkManager: NetworkManager) {
		self.drinkRepo = DrinkRepo(networkManager: networkManager)
	}

	func fetchDrinks(with name: String) {
		guard !name.isEmpty else {
			if let nonFilteredDrinks = nonFilteredDrinks {
				searchResultState = .notFiltered(models: nonFilteredDrinks)
				delegate?.reloadCollectionView()
			} else {
                drinkRepo.fetchAllDrinks(completion: fetchDrinksCompletionHandler)
			}
			return
		}

        drinkRepo.fetchDrinks(with: name, completion: fetchDrinksFilteredCompletionHandler)
	}
}
