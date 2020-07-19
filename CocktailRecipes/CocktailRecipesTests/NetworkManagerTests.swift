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

    func makeDictionaryData() -> Data? {
        let json = """
        {"lorem": "ipsum"}
        """
        
        return json.data(using: .utf8)
    }
    
    func makeArrayData() {
        func makeDictionaryData() -> Data? {
            let json = """
            {["lorem": "ipsum",
            "lorem": "ipsum"]}
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
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
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
