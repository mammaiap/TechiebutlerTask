//
//  PostDetailUIComposer.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//

import Foundation
import UIKit

final class PostDetailUIComposer {
    private init() {}
    
    public static func postDetailComposedWith(model: Post) -> PostDetailViewController {
        
        let viewModel = PostDetailViewModel(model: model)
        
        let detailController = PostDetailViewController.makeWith(viewModel: viewModel)
        
        return detailController
    }
    
    
}

private extension PostDetailViewController {
    static func makeWith(viewModel: PostDetailViewModel) -> PostDetailViewController {
        let bundle = Bundle(for: PostDetailViewController.self)
        let storyboard = UIStoryboard(name: "PostDetail", bundle: bundle)
        let detailController = storyboard.instantiateInitialViewController{ coder in
            PostDetailViewController(viewModel: viewModel, coder: coder)
        }!
        return detailController
    }
}
