//
//  PostLoader.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//

import Foundation

struct PagedPostRequest: Equatable {
    let start: Int
    let limit: Int

    init(start: Int, limit: Int = 10) {
        self.start = start
        self.limit = limit
  }
}

protocol PostLoader{
    typealias Result = Swift.Result<[Post], Error>
    func load(_ req: PagedPostRequest, completion: @escaping (Result) -> Void)
}
