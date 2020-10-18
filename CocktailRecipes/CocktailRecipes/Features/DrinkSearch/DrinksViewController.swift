//
//  DrinksViewController.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/20/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import UIKit

final class DrinksViewController: UIViewController {

	private let presenter = DrinksPresenter(networkManager: NetworkManager())
	private lazy var searchController: UISearchController = {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchResultsUpdater = self
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.obscuresBackgroundDuringPresentation = false
		return searchController
	}()

	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
		collectionView.backgroundColor = .white
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.keyboardDismissMode = .onDrag
		collectionView.register(LargeDrinkCell.self, forCellWithReuseIdentifier: LargeDrinkCell.identifier)
		collectionView.dataSource = self
		return collectionView
	}()

	private let debouncer = Debouncer(delay: 0.3)
	private var searchTextDisplayed = ""

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		navigationItem.title = "Drinks"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		view.addSubview(collectionView)
		NSLayoutConstraint.activate([
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		presenter.delegate = self
		debouncer.delegate = self
		presenter.fetchDrinks(with: "")
    }

	private func generateLayout() -> UICollectionViewLayout {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .fractionalHeight(1.0))
		let drinkItem = NSCollectionLayoutItem(layoutSize: itemSize)
		drinkItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)

		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .absolute(200))
		let group = NSCollectionLayoutGroup.horizontal(
			layoutSize: groupSize, subitem: drinkItem, count: 2)

		let section = NSCollectionLayoutSection(group: group)
		return UICollectionViewCompositionalLayout(section: section)
	}

}

extension DrinksViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let searchResultState = presenter.searchResultState
		switch searchResultState {
		case .notFiltered(let drinks), .filtered(let drinks):
			return drinks.count
		case .error:
			return 0
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: LargeDrinkCell.identifier, for: indexPath) as? LargeDrinkCell else {
			return UICollectionViewCell()
		}

		let searchResultState = presenter.searchResultState
		switch searchResultState {
		case .notFiltered(let drinks), .filtered(let drinks):
			let drink = drinks[indexPath.item]
			cell.configure(image: nil, text: drink.name)
		case .error:
			return UICollectionViewCell()
		}

		return cell
	}
}

extension DrinksViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		debouncer.call()
	}

}

extension DrinksViewController: DrinksPresenterDelegate {
	func reloadCollectionView() {
		collectionView.reloadData()
	}
}

extension DrinksViewController: DebouncerDelegate {
	func didFireDebouncer(_ debouncer: Debouncer) {
		guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
			return
		}
		guard searchText != searchTextDisplayed else { return }
		searchTextDisplayed = searchText
		presenter.fetchDrinks(with: searchText)
	}
}
