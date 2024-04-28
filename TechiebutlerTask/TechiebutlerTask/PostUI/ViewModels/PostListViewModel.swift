//
//  PostListViewModel.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//
//

import Foundation

final class PostListViewModel {
    typealias Observer<T> = (T) -> Void
    var onLoadingStateChange: Observer<Bool>?
    var onPostLoad: Observer<[Post]>?
    var onErrorStateChange: Observer<String?>?    
    
    private var paginatedStart: Int = 0
    private let paginatedLimit: Int = 10
    private let paginatedMaxlimit: Int = 100

    private let postLoader: PostLoader

    init(postLoader: PostLoader) {
        self.postLoader = postLoader
    }
    
    private var memoizedPosts: [Int : [Post]] = [ : ]

}

extension PostListViewModel{
    var isFirst: Bool {
        if(paginatedStart == 0){
            return true
        }else{
            return false
        }
    }
    
    var isLast: Bool {
        if(paginatedStart >= paginatedMaxlimit){
            return true
        }else{
            return false
        }
    }
   
    
    var listViewtitle: String {
        Localized.Post.listViewtitle
    }
}

extension PostListViewModel{
    func loadPost() {
        if let posts = memoizedPosts[paginatedStart] {            
            self.onPostLoad?(posts)
            self.paginatedStart += self.paginatedLimit
        }
        onErrorStateChange?(.none)
        onLoadingStateChange?(true)
        
        postLoader.load(.init(start: paginatedStart, limit: paginatedLimit)) { [weak self] result in
            guard let self = self else { return }
            if let posts = try? result.get() {
                memoizedPosts[paginatedStart] = posts
                self.onPostLoad?(posts)
                self.paginatedStart += self.paginatedLimit
            } else {
                self.onErrorStateChange?(Localized.Post.loadError)
            }
            self.onLoadingStateChange?(false)
            
        }
    }
}
