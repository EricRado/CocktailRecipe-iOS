//
//  UIImageView+Request.swift
//  CocktailRecipes
//
//  Created by Jaison Vieira on 11/15/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(from url: String, networkManager: NetworkManager = NetworkManager()) {
        networkManager.requestImage(url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    break
                case .success(let image):
                    self?.image = image
                }
            }
        }
    }
}
