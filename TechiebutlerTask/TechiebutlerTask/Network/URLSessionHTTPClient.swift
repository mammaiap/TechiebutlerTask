//
//  URLSessionHTTPClient.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    private struct URLSessionTaskWrapper: HTTPClientTask{
        let wrapped: URLSessionTask
        func cancel() {
            wrapped.cancel()
        }
        
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    func get(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
       
        let task = session.dataTask(with: request) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
        
    }
    
}
