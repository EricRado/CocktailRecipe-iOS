//
//  IngredientRepo.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 6/20/21.
//  Copyright © 2021 Eric Rado. All rights reserved.
//

import Foundation

struct IngredientRepo {
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchIngredients(with name: String, completion: @escaping (Result<[Ingredient], Error>) -> ()) {
        let ingredientsCompletionHandler: (Result<IngredientResponseDTO, Error>) -> () = { result in
            switch result {
            case .success(let ingredientResponseDTO):
                let ingredients = ingredientResponseDTO.ingredients.map { Ingredient(dto: $0) }
                completion(.success(ingredients))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        networkManager.request(IngredientEndpoint.search(name: name), completion: ingredientsCompletionHandler)
    }
    
    func fetchAllIngredients(completion: @escaping (Result<IngredientSlimList, Error>) -> ()) {
        let ingredientSlimListCompletionHandler: (Result<IngredientSlimListDTO, Error>) -> () = { result in
            switch result {
            case .success(let ingredientSlimListDTO):
                let ingredientSlimList = IngredientSlimList(dto: ingredientSlimListDTO)
                completion(.success(ingredientSlimList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        networkManager.request(IngredientEndpoint.list, completion: ingredientSlimListCompletionHandler)
    }
}
