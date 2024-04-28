//
//  PostViewModel.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//
//

import Foundation

final class PostViewModel{
    private let model: Post

    init(model: Post) {
        self.model = model
    }    
}

extension PostViewModel{
    
    var id: String {
        return "\(model.id)"
    }

    var title: String {
        return model.title
    }
    
}

extension PostViewModel{
    func getPostModel() -> Post {
        return model
    }
}
