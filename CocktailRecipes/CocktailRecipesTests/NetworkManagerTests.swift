//
//  NetworkManagerTests.swift
//  CocktailRecipesTests
//
//  Created by Jaison Vieira on 7/19/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import XCTest
@testable import CocktailRecipes

class NetworkManagerTests: XCTestCase {

    func testRequestObjectIsSuccessful() {
        let data = makeDictionaryData()

        let session = MockSession(response: (data, URLResponse: nil, error: nil))
        let networkManager = NetworkManager(session: session)

        let expectation = self.expectation(description: "Send mock request")

        let completion: (Result<[String: String], Error>) -> Void = { result in
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success(let response):
                XCTAssertEqual(["lorem": "ipsum"], response)
            }

            expectation.fulfill()
        }

        networkManager.request(MockEndpoint(), completion: completion)
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testRequestObjectListIsSuccessful() {
        let data = makeArrayData()

        let session = MockSession(response: (data, URLResponse: nil, error: nil))
        let networkManager = NetworkManager(session: session)

        let expectation = self.expectation(description: "Send mock request")

        let completion: (Result<[[String: String]], Error>) -> Void = { result in
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success(let response):
                XCTAssertNotNil(response)
            }

            expectation.fulfill()
        }

        networkManager.request(MockEndpoint(), completion: completion)
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testRequestObjectIsNotSuccessful() {
        let session = MockSession(response: (nil, URLResponse: nil, error: NetworkError.unknown))
        let networkManager = NetworkManager(session: session)

        let expectation = self.expectation(description: "Send mock request")

        let completion: (Result<[String: String], Error>) -> Void = { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error as? NetworkError, NetworkError.unknown)
            case .success(let response):
                XCTAssertNil(response)
            }

            expectation.fulfill()
        }

        networkManager.request(MockEndpoint(), completion: completion)
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testRequestObjectHasIncorrectData() {
        let data = "".data(using: .utf8)

        let session = MockSession(response: (data, URLResponse: nil, error: nil))
        let networkManager = NetworkManager(session: session)

        let expectation = self.expectation(description: "Send mock request")

        let completion: (Result<[String: String], Error>) -> Void = { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success(let response):
                XCTAssertNil(response)
            }

            expectation.fulfill()
        }

        networkManager.request(MockEndpoint(), completion: completion)
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testRequestObjectUnknownError() {

        let session = MockSession(response: (nil, URLResponse: nil, error: nil))
        let networkManager = NetworkManager(session: session)

        let expectation = self.expectation(description: "Send mock request")

        let completion: (Result<[String: String], Error>) -> Void = { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error as? NetworkError, NetworkError.unknown)
            case .success(let response):
                XCTAssertNil(response)
            }

            expectation.fulfill()
        }

        networkManager.request(MockEndpoint(), completion: completion)
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func makeDictionaryData() -> Data? {
        let json = """
        {"lorem": "ipsum"}
        """

        return json.data(using: .utf8)
    }

    func makeArrayData() -> Data? {
        let json = """
        [{"lorem": "ipsum"},
        {"lorem": "ipsum"}]
        """

        return json.data(using: .utf8)
    }
}
