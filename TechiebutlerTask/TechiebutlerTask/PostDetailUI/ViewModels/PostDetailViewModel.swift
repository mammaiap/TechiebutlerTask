//
//  PostDetailViewModel.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//
//

import Foundation

final class PostDetailViewModel{
    private let model: Post

    init(model: Post) {
        self.model = model
    }    
}

extension PostDetailViewModel{
    
    var userId: String {
        return "\(model.userId)"
    }
    
    var id: String {
        return "\(model.id)"
    }

    var title: String {
        return model.title
    }
    
    var body: String {
        return model.body
    }
    
    var viewTitle: String {
        Localized.Post.detailViewTitle
    }
    
}


