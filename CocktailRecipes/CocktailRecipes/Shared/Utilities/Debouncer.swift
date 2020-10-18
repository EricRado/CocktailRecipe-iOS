//
//  Debouncer.swift
//  CocktailRecipes
//
//  Created by Eric Rado on 10/17/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import Foundation

protocol DebouncerDelegate: AnyObject {
	func didFireDebouncer(_ debouncer: Debouncer)
}

final class Debouncer {
	weak var delegate: DebouncerDelegate?
	var delay: Double
	weak var timer: Timer?

	init(delay: Double) {
		self.delay = delay
	}

	func call() {
		timer?.invalidate()
		let nextTimer = Timer.scheduledTimer(
			timeInterval: delay, target: self, selector: #selector(fireNow), userInfo: nil, repeats: false)
		timer = nextTimer
	}

	@objc private func fireNow() {
		delegate?.didFireDebouncer(self)
	}
}
