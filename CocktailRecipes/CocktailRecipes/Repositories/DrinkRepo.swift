//
//  DrinkRepo.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 6/20/21.
//  Copyright © 2021 Eric Rado. All rights reserved.
//

import Foundation

struct DrinkRepo {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchDrinks(by responseType: DrinkResponseType, completion: @escaping (Result<[Drink], Error>) -> ()) {
        let drinksCompletionHandler: (Result<DrinkResponseDTO, Error>) -> () = { result in
            switch result {
            case .success(let drinkResponseDTO):
                let drinks = drinkResponseDTO.drinks.map { Drink(dto: $0) }
                completion(.success(drinks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        switch responseType {
        case .popular:
            networkManager.request(CocktailEndpoint.popular, completion: drinksCompletionHandler)
        case .latest:
            networkManager.request(CocktailEndpoint.latest, completion: drinksCompletionHandler)
        case .random:
            networkManager.request(CocktailEndpoint.random, completion: drinksCompletionHandler)
        }
    }
    
    func fetchDrinks(with name: String, completion: @escaping (Result<[Drink], Error>) -> ()) {
        let drinksCompletionHandler: (Result<DrinkResponseDTO, Error>) -> () = { result in
            switch result {
            case .success(let drinkResponseDTO):
                let drinks = drinkResponseDTO.drinks.map { Drink(dto: $0) }
                completion(.success(drinks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        networkManager.request(CocktailEndpoint.searchWithName(name), completion: drinksCompletionHandler)
    }
    
    func fetchAllDrinks(completion: @escaping (Result<[Drink], Error>) -> ()) {
        let drinksCompletionHandler: (Result<DrinkResponseDTO, Error>) -> () = { result in
            switch result {
            case .success(let drinkResponseDTO):
                let drinks = drinkResponseDTO.drinks.map { Drink(dto: $0) }
                completion(.success(drinks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        networkManager.request(CocktailEndpoint.searchWithName(""), completion: drinksCompletionHandler)
    }
}
