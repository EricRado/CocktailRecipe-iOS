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
	private let networkManager: NetworkManager
	private(set) var drinks = [Drink]()
	private lazy var fetchDrinksCompletionHandler: (Result<DrinkResponse, Error>) -> Void = { [weak self] result in
		guard let self = self else { return }
		switch result {
		case .success(let drinkResponse):
			self.drinks = drinkResponse.drinks
			DispatchQueue.main.async {
				self.delegate?.reloadCollectionView()
			}
		case .failure(let error):
			print(error.localizedDescription)
		}
	}

	init(networkManager: NetworkManager) {
		self.networkManager = networkManager
	}

	func fetchDrinks(with name: String) {
		networkManager.request(
			CocktailEndpoint.searchWithName(name), completion: fetchDrinksCompletionHandler)
	}
}
