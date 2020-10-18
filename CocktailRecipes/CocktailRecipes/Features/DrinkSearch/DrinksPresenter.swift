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
	func reloadCollectionView(searchResultState: SearchResultState<[Drink]>)
}

final class DrinksPresenter {
	weak var delegate: DrinksPresenterDelegate?
	private let networkManager: NetworkManager
	private var nonFilteredDrinks: [Drink]?

	private lazy var fetchDrinksFilteredCompletionHandler: (Result<DrinkResponse, Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case .success(let drinkResponse):
			DispatchQueue.main.async {
				self.delegate?.reloadCollectionView(searchResultState: .filtered(drinks: drinkResponse.drinks))
			}
		case .failure(let error):
			DispatchQueue.main.async {
				self.delegate?.reloadCollectionView(searchResultState: .error(message: error.localizedDescription))
			}
		}
	}
	
	private lazy var fetchDrinksCompletionHandler: (Result<DrinkResponse, Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case .success(let drinkResponse):
			self.nonFilteredDrinks = drinkResponse.drinks
			DispatchQueue.main.async {
				self.delegate?.reloadCollectionView(
					searchResultState: .notFiltered(drinks: self.nonFilteredDrinks ?? []))
			}
		case .failure(let error):
			DispatchQueue.main.async {
				self.delegate?.reloadCollectionView(searchResultState: .error(message: error.localizedDescription))
			}
		}
	}

	init(networkManager: NetworkManager) {
		self.networkManager = networkManager
	}

	func fetchDrinks(with name: String) {
		guard !name.isEmpty else {
			if let nonFilteredDrinks = nonFilteredDrinks {
				delegate?.reloadCollectionView(searchResultState: .notFiltered(drinks: nonFilteredDrinks))
			} else {
				networkManager.request(CocktailEndpoint.searchWithName(name), completion: fetchDrinksCompletionHandler)
			}
			return
		}

		networkManager.request(
			CocktailEndpoint.searchWithName(name), completion: fetchDrinksFilteredCompletionHandler)
	}
}
