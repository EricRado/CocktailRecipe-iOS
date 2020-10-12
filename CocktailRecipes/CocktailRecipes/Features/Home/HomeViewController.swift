//
//  HomeViewController.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/20/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {

	private let presenter = HomePresenter(networkManager: NetworkManager())
	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
		collectionView.backgroundColor = .white
		collectionView.register(SmallDrinkCell.self, forCellWithReuseIdentifier: SmallDrinkCell.identifier)
		collectionView.register(MediumDrinkCell.self, forCellWithReuseIdentifier: MediumDrinkCell.identifier)
		collectionView.register(LargeDrinkCell.self, forCellWithReuseIdentifier: LargeDrinkCell.identifier)
		collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.dataSource = self
		return collectionView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white

		presenter.delegate = self
		view.addSubview(collectionView)
		NSLayoutConstraint.activate([
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
    }

extension HomeViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionType = presenter.sectionType(for: section)
		return presenter.dataSource(for: sectionType).count
	}

	func collectionView(
		_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let sectionType = presenter.sectionType(for: indexPath.section)
		let dataSource = presenter.dataSource(for: sectionType)
		let drink = dataSource[indexPath.row]

		switch sectionType {
		case .random:
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: LargeDrinkCell.identifier, for: indexPath) as? LargeDrinkCell else {
				return UICollectionViewCell()
			}
			cell.configure(image: nil, text: drink.name)
			return cell
		case .latest:
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: MediumDrinkCell.identifier, for: indexPath) as? MediumDrinkCell else {
				return UICollectionViewCell()
			}
			cell.configure(image: nil, text: drink.name)
			return cell
		case .popular:
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: SmallDrinkCell.identifier, for: indexPath) as? SmallDrinkCell else {
				return UICollectionViewCell()
			}
			cell.configure(image: nil, text: drink.name)
			return cell
		}

	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return presenter.sectionCount
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as? SectionHeader else { fatalError("Could not deque SectionHeader") }
		headerView.configure(text: presenter.title(for: indexPath.section))
		return headerView
	}
}

extension HomeViewController: HomeViewDelegate {
	func reloadCollectionView(for section: Int) {
		collectionView.reloadSections(IndexSet(integer: section))
	}
}
