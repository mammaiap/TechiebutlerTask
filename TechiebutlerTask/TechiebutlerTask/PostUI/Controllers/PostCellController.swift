//
//  PostCellController.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//

import Foundation
import UIKit

final class PostCellController: Hashable, Equatable{
    private let viewModel: PostViewModel
    private var cell: PostCell?

    init(viewModel: PostViewModel) {
        self.viewModel = viewModel
    }

    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = binded(tableView.dequeueReusableCell())
        return cell
    }

    func preload() {
      // if any heavy prefetching is required here we can do that.. like thumbnail fetching..
    }

    func cancelLoad() {
        releaseCellForReuse()
     
    }

    private func binded(_ cell: PostCell) -> PostCell {
        self.cell = cell
        cell.idLabel.text = viewModel.id
        cell.titleLabel.text = viewModel.title
        
        return cell
    }

    private func releaseCellForReuse() {
        cell = nil
    }
    
    func getPostModel() -> Post {
        viewModel.getPostModel()
    }
    
    static func == (lhs: PostCellController, rhs: PostCellController) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(viewModel.id)
    }
}
