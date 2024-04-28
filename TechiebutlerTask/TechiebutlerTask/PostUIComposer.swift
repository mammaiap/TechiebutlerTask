//
//  PostUIComposer.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//

import Foundation
import UIKit

final class PostUIComposer {
    private init() {}
    
    public static func postComposedWith(
        postLoader: PostLoader,
        onSelection: @escaping (Post) -> Void
        ) -> PostListViewController {
        
        let postListViewModel = PostListViewModel(
            postLoader: MainQueueDispatchDecorator(decoratee: postLoader))

        let listViewController = PostListViewController.makeWith(
            viewModel: postListViewModel,onSelection: onSelection)

            postListViewModel.onPostLoad = adaptPostToCellControllers(
            forwardingTo: listViewController)
        
        return listViewController
    }
    
    private static func adaptPostToCellControllers(forwardingTo controller: PostListViewController) -> ([Post]) -> Void {
        return { [weak controller] feed in
            let newItems = feed.map { model in
                PostCellController(viewModel: PostViewModel(model: model))
            }
            controller?.displayNewlyFetchedItems(newItems)            
        }
    }
    
}

private extension PostListViewController {
    static func makeWith(viewModel: PostListViewModel, onSelection: @escaping (Post) -> Void) -> PostListViewController {
        let bundle = Bundle(for: PostListViewController.self)
        let storyboard = UIStoryboard(name: "Post", bundle: bundle)       
        let postController = storyboard.instantiateInitialViewController() as! PostListViewController
        postController.viewModel = viewModel
        postController.onSelection = onSelection
        return postController
    }
}


