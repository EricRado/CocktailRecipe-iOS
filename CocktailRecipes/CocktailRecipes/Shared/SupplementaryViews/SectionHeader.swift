//
//  SectionHeader.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/21/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
	private let label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Popular"
		label.textColor = .label
		label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize, weight: .bold)
		return label
	} ()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		addSubview(label)
		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			label.topAnchor.constraint(equalTo: topAnchor, constant: 8)
		])
	}

	func configure(text: String) {
		label.text = text
	}
}
