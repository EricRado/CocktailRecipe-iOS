//
//  HomePresenterTests.swift
//  CocktailRecipesTests
//
//  Created by Jaison Vieira on 10/22/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import XCTest
@testable import CocktailRecipes

class HomePresenterTests: XCTestCase {

    func testDataSourceSuccessFetch() {
        let homePresenter = constructHomePresenter()

        XCTAssertGreaterThan(homePresenter.dataSource(for: .random).count, 0)
        XCTAssertGreaterThan(homePresenter.dataSource(for: .latest).count, 0)
        XCTAssertGreaterThan(homePresenter.dataSource(for: .popular).count, 0)
    }

    func testDataSourceFailFetch() {
        let homePresenter = constructFailingHomePresenter()

        XCTAssertEqual(homePresenter.dataSource(for: .random).count, 0)
        XCTAssertEqual(homePresenter.dataSource(for: .latest).count, 0)
        XCTAssertEqual(homePresenter.dataSource(for: .popular).count, 0)
    }

    private func constructHomePresenter() -> HomePresenter {
        return HomePresenter(networkManager: constructNetworkManager())
    }

    private func constructFailingHomePresenter() -> HomePresenter {
        let session = MockSession(response: (Data(), URLResponse: nil, error: nil))
        return HomePresenter(networkManager: NetworkManager(session: session))
    }

    private func constructNetworkManager() -> NetworkManager {

        let data = contstructDrinkData()

        let session = MockSession(response: (data, URLResponse: nil, error: nil))
        return NetworkManager(session: session)
    }

    private func contstructDrinkData() -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "drinks", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load drinks.json.")
        }

        return data
    }
}
