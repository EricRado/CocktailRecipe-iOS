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
    private let numberOfRowsInSection = 5
	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
		collectionView.backgroundColor = .white
		collectionView.register(SmallDrinkCell.self, forCellWithReuseIdentifier: SmallDrinkCell.identifier)
		collectionView.register(LargeDrinkCell.self, forCellWithReuseIdentifier: LargeDrinkCell.identifier)
		collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.identifier)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.isHidden = false
    }

	private func makeLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
			switch self.presenter.sectionType(for: sectionIndex) {
			case .random:
				return self.createFirstSectionLayout()
			case .latest, .popular:
				return self.createThirdSectionLayout()
			}
		}

		let configuration = UICollectionViewCompositionalLayoutConfiguration()
		configuration.interSectionSpacing = 20
		layout.configuration = configuration
		return layout
	}
}

extension HomeViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionType = presenter.sectionType(for: section)
        let counter = presenter.dataSource(for: sectionType).count
        return counter < numberOfRowsInSection ? counter : numberOfRowsInSection
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
		case .latest, .popular:
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

	func collectionView(
		_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath) -> UICollectionReusableView {
		guard let headerView = collectionView.dequeueReusableSupplementaryView(
			ofKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: SectionHeader.identifier,
			for: indexPath) as? SectionHeader else { fatalError("Could not dequeue SectionHeader") }
        headerView.configure(text: presenter.title(for: indexPath.section), sectionIndex: indexPath.section)
        headerView.delegate = self
		return headerView
	}
}

// MARK: - Compositional Layout Helpers
extension HomeViewController {
	private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
		let layoutSectionHeaderSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
		return NSCollectionLayoutBoundarySupplementaryItem(
			layoutSize: layoutSectionHeaderSize,
			elementKind: UICollectionView.elementKindSectionHeader,
			alignment: .top)
	}

	private func createFirstSectionLayout() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
		layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(0.95), heightDimension: .estimated(250))
		let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])

		let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
		layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
		layoutSection.boundarySupplementaryItems = [createSectionHeader()]

		return layoutSection
	}

	private func createSecondSectionLayout() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(0.45), heightDimension: .fractionalHeight(0.5))
		let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
		layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(0.95), heightDimension: .estimated(250))
		let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: layoutItem, count: 2)

		let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
		layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
		layoutSection.boundarySupplementaryItems = [createSectionHeader()]

		return layoutSection
	}

	private func createThirdSectionLayout() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)

		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))

		let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [layoutItem])
		let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
		layoutSection.interGroupSpacing = 15
		layoutSection.boundarySupplementaryItems = [createSectionHeader()]
		return layoutSection
	}
}

extension HomeViewController: HomeViewDelegate {
	func reloadCollectionView(for section: Int) {
		collectionView.reloadSections(IndexSet(integer: section))
	}
}

extension HomeViewController: SectionHeaderDelegate {
    func didTapShowMoreForSectionHeader(_ sectionHeader: SectionHeader, sectionIndex: Int) {
        let sectionType = presenter.sectionType(for: sectionIndex)
        let dataSource = presenter.dataSource(for: sectionType)

        let drinkChartPresenter = DrinkChartPresenter(drinks: dataSource)
        let drinkChartCollectionViewController = DrinkChartCollectionViewController(presenter: drinkChartPresenter)
        drinkChartCollectionViewController.title = sectionType.title

        navigationController?.pushViewController(drinkChartCollectionViewController, animated: true)
    }
}
