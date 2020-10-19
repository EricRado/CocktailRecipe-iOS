//
//  DrinkListViewController.swift
//  CocktailRecipes
//
//  Created by Jaison Vieira on 10/17/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import UIKit

class DrinkListViewController: UICollectionViewController {

    private let presenter: DrinkListPresenter

    init(presenter: DrinkListPresenter) {
        self.presenter = presenter
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        collectionView.register(SmallDrinkCell.self, forCellWithReuseIdentifier: SmallDrinkCell.identifier)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.itemsCount()
    }

    override func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SmallDrinkCell.identifier, for: indexPath) as? SmallDrinkCell else {
            return UICollectionViewCell()
        }

        let drink = presenter.itemForRow(indexPath.row)
        cell.configure(image: nil, text: drink.name, rank: indexPath.row + 1)

        return cell
    }
}

extension DrinkListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
}
