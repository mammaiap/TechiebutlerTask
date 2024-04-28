//
//  RemotePostLoader.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//

import Foundation

final class RemotePostLoader: PostLoader {
    private let baseURL: URL
    private let client: HTTPClient
    
    init(baseURL: URL, client: HTTPClient) {
        self.baseURL = baseURL
        self.client = client
    }
    
    typealias Result = PostLoader.Result
    
    enum Error: Swift.Error{
        case connectivity
        case invalidData
    }
    
    func load(_ req: PagedPostRequest,completion: @escaping (Result) -> Void) {
        let request = URLRequest(url: enrich(baseURL, with: req))
        client.get(request) {[weak self] result in
            guard self != nil else { return }
            
            switch result{
            case let .success((data,response)):
                completion(RemotePostLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            
            }
            
        }
        
    }
    
}

private extension RemotePostLoader {
    private func enrich(_ url: URL, with req: PagedPostRequest) -> URL {

      let requestURL = url
       
      var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
      urlComponents?.queryItems = [
        URLQueryItem(name: "_start", value: "\(req.start)"),
        URLQueryItem(name: "_limit", value: "\(req.limit)")
      ]
      
      return urlComponents?.url ?? requestURL
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do{
            let items = try PostItemsMapper.map(data, response: response)
            return (.success(items))
        }catch{
            return(.failure(error))
        }
        
    }
}
