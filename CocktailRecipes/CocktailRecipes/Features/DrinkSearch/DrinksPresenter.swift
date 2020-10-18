//
//  DrinksPresenter.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 10/14/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import Foundation

enum SearchResultState<T: Decodable> {
	case notFiltered(drinks: T)
	case filtered(drinks: T)
	case error(message: String)
}

protocol DrinksPresenterDelegate: AnyObject {
	func reloadCollectionView()
}

final class DrinksPresenter {
	weak var delegate: DrinksPresenterDelegate?
	private let networkManager: NetworkManager
	private var nonFilteredDrinks: [Drink]?
	private(set) var searchResultState: SearchResultState<[Drink]> = .notFiltered(drinks: [])

	private lazy var fetchDrinksFilteredCompletionHandler: (Result<DrinkResponse, Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case .success(let drinkResponse):
			self.searchResultState = .filtered(drinks: drinkResponse.drinks)
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

	private lazy var fetchDrinksCompletionHandler: (Result<DrinkResponse, Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case .success(let drinkResponse):
			self.nonFilteredDrinks = drinkResponse.drinks
			self.searchResultState = .notFiltered(drinks: self.nonFilteredDrinks ?? [])
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
		self.networkManager = networkManager
	}

	func fetchDrinks(with name: String) {
		guard !name.isEmpty else {
			if let nonFilteredDrinks = nonFilteredDrinks {
				searchResultState = .notFiltered(drinks: nonFilteredDrinks)
				delegate?.reloadCollectionView()
			} else {
				networkManager.request(CocktailEndpoint.searchWithName(name), completion: fetchDrinksCompletionHandler)
			}
			return
		}

		networkManager.request(
			CocktailEndpoint.searchWithName(name), completion: fetchDrinksFilteredCompletionHandler)
	}
}
