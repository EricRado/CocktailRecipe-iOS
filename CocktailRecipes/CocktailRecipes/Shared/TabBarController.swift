//
//  TabBarController.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/20/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white

        let homePresenter = HomePresenter(networkManager: NetworkManager())
        let homeViewController = HomeViewController(presenter: homePresenter)
		let homeNavigationViewController = UINavigationController(rootViewController: homeViewController)
        homeNavigationViewController.tabBarItem.image = UIImage(named: "home")
        homeNavigationViewController.tabBarItem.title = ""

		let drinksViewController = DrinksViewController()
		drinksViewController.tabBarItem.image = UIImage(named: "cocktail")
		drinksViewController.tabBarItem.title = ""
		let drinksNavigationController = UINavigationController(rootViewController: drinksViewController)

		let ingredientsViewController = IngredientsViewController()
		ingredientsViewController.tabBarItem.image = UIImage(named: "ingredient")
		ingredientsViewController.tabBarItem.title = ""

		let savedDrinksViewController = SavedDrinksViewController()
		savedDrinksViewController.tabBarItem.image = UIImage(named: "bookmark")
		savedDrinksViewController.tabBarItem.title = ""

		setViewControllers([
            homeNavigationViewController,
			drinksNavigationController,
			ingredientsViewController,
			savedDrinksViewController
			], animated: true)
		selectedIndex = 0
    }

}
