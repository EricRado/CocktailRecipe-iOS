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
        let sut = makeSUT()

        XCTAssertGreaterThan(sut.dataSource(for: .random).count, 0)
        XCTAssertGreaterThan(sut.dataSource(for: .latest).count, 0)
        XCTAssertGreaterThan(sut.dataSource(for: .popular).count, 0)
    }

    func testDataSourceFailFetch() {
        let sut = makeFailingSUT()

        XCTAssertEqual(sut.dataSource(for: .random).count, 0)
        XCTAssertEqual(sut.dataSource(for: .latest).count, 0)
        XCTAssertEqual(sut.dataSource(for: .popular).count, 0)
    }

    private func makeSUT() -> HomePresenter {
        return HomePresenter(networkManager: makeNetworkManager())
    }

    private func makeFailingSUT() -> HomePresenter {
        let session = MockSession(response: (Data(), URLResponse: nil, error: nil))
        return HomePresenter(networkManager: NetworkManager(session: session))
    }

    private func makeNetworkManager() -> NetworkManager {

        let data = makeDrinkArrayData()

        let session = MockSession(response: (data, URLResponse: nil, error: nil))
        return NetworkManager(session: session)
    }

    private func makeDrinkArrayData() -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "drinks", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load drinks.json.")
        }

        return data
    }
}
