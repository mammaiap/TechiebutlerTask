//
//  PostItemsMapper.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//

import Foundation

final class PostItemsMapper {
    
    private init() {}
        
    struct RemotePostItem: Decodable {
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }
    
    static func map(_ data: Data, response: HTTPURLResponse) throws -> [Post] {
        
        guard response.isOK,
              let content: [RemotePostItem] = convertToModel(data: data) else{
            throw RemotePostLoader.Error.invalidData
        }
        
        return content.toPostModels
        
    }
    
    static func convertToModel<T: Decodable>(data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let modelData = try decoder.decode(T.self, from: data)
            return modelData
        } catch {
            return nil
        }
    }
    
    
}


private extension Array where Element == PostItemsMapper.RemotePostItem {
    var toPostModels: [Post] {
        map { Post(userId: $0.userId, id: $0.id, title: $0.title, body: $0.body)}
    }
    
}
