//
//  LargeDrinkCell.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/21/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import UIKit

final class LargeDrinkCell: UICollectionViewCell {
	private let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = UIColor.gray
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	private let label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.preferredFont(forTextStyle: .body)
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {
		imageView.image = nil
		label.text = nil
	}

	private func setupView() {
		contentView.addSubview(imageView)
		contentView.addSubview(label)

		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
			imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
		])

		NSLayoutConstraint.activate([
			label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
			label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16)
		])
	}

	func configure(image: UIImage?, text: String) {
		imageView.image = image
		label.text = text
	}
}
