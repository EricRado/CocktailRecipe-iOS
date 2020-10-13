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

fileprivate class MockSession: URLSession {

    typealias Response = (data: Data?, URLResponse: URLResponse?, error: Error?)
    private let response: Response

    init(response: Response) {
        self.response = response
    }

    override func dataTask(with request: URLRequest,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockTask(response: response, completionHandler: completionHandler)
    }
}

fileprivate class MockTask: URLSessionDataTask {

    typealias Response = (data: Data?, URLResponse: URLResponse?, error: Error?)
    typealias Completion = ((Data?, URLResponse?, Error?) -> Void)

    var mockResponse: Response
    let completionHandler: Completion

    init(response: Response, completionHandler: @escaping Completion) {
        self.mockResponse = response
        self.completionHandler = completionHandler
    }

    override func resume() {
        completionHandler(mockResponse.data, mockResponse.URLResponse, mockResponse.error)
    }
}

fileprivate class MockEndpoint: EndpointConstructable {
    var path: String = ""
    var httpMethod: HTTPMethod = .get
    var httpTask: HTTPTask = .request
}
