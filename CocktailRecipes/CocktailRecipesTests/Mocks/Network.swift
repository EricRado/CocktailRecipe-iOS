//
//  Network.swift
//  CocktailRecipesTests
//
//  Created by Jaison Vieira on 10/22/20.
//  Copyright © 2020 Eric Rado. All rights reserved.
//

import Foundation
@testable import CocktailRecipes

class MockSession: URLSession {

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

class MockTask: URLSessionDataTask {

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

class MockEndpoint: EndpointConstructable {
    var path: String = ""
    var httpMethod: HTTPMethod = .get
    var httpTask: HTTPTask = .request
}
