//
//  DrinkChartCollectionViewController.swift
//  CocktailRecipes
//
//  Created by Jaison Vieira on 10/17/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import UIKit

class DrinkChartCollectionViewController: UICollectionViewController {

    private let presenter: DrinkChartPresenter

    init(presenter: DrinkChartPresenter) {
        self.presenter = presenter
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(DrinkChartCell.self, forCellWithReuseIdentifier: DrinkChartCell.identifier)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.itemsCount()
    }

    override func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DrinkChartCell.identifier, for: indexPath) as? DrinkChartCell else {
            return UICollectionViewCell()
        }

        let drink = presenter.itemForRow(indexPath.row)
        cell.configure(image: nil, rank: indexPath.row + 1, text: drink.name)

        return cell
    }
}

extension DrinkChartCollectionViewController: UICollectionViewDelegateFlowLayout {

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
