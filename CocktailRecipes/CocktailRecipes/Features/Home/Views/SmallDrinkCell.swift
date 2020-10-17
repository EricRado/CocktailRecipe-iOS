//
//  SmallDrinkCell.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/21/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import UIKit

final class SmallDrinkCell: UICollectionViewCell {
	private let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .gray
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	private let label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.preferredFont(forTextStyle: .body)
		label.contentHuggingPriority(for: .vertical)
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
		super.prepareForReuse()
		imageView.image = nil
		label.text = nil
	}

	private func setupView() {
		contentView.addSubview(imageView)
		contentView.addSubview(label)

		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
			imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
		])

		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 24),
			label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
	}

	func configure(image: UIImage?, text: String) {
		imageView.image = image
		label.text = text
	}
}
