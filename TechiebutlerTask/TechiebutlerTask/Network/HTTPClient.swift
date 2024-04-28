//
//  HTTPClient.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//

import Foundation

protocol HTTPClientTask {
    func cancel()
}

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func get(_ request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask
    
}
