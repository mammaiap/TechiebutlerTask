//
//  PostViewModel.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//
//

import Foundation

final class PostCellViewModel{
    private let model: Post

    init(model: Post) {
        self.model = model
    }    
}

extension PostCellViewModel{
    
    var id: String {
        return "\(model.id)"
    }

    var title: String {
        return model.title
    }
    
}

extension PostCellViewModel{
    func getPostModel() -> Post {
        return model
    }
}
