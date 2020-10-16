//
//  SectionHeader.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 7/21/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import UIKit

protocol SectionHeaderDelegate: AnyObject {
    func didTapShowMoreForSectionHeader(_ sectionHeader: SectionHeader, sectionIndex: Int)
}

final class SectionHeader: UICollectionReusableView {
	private let label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Popular"
		label.textColor = .label
		label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize, weight: .bold)
		return label
	}()

    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show more", for: .normal)
        button.addTarget(self, action: #selector(showMore), for: .touchUpInside)
        return button
    }()

    weak var delegate: SectionHeaderDelegate?

    private var sectionIndex = 0

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		addSubview(label)
        addSubview(button)

		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			label.topAnchor.constraint(equalTo: topAnchor, constant: 8)
		])

        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: label.bottomAnchor)
        ])
	}

    func configure(text: String, sectionIndex: Int) {
		label.text = text
        self.sectionIndex = sectionIndex
	}

    @objc private func showMore() {
        delegate?.didTapShowMoreForSectionHeader(self, sectionIndex: sectionIndex)
    }
}
