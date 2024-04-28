//
//  PostListViewController.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//

import Foundation
import UIKit

final class PostListViewController: UITableViewController , UITableViewDataSourcePrefetching {
    private var isViewAppeared: Bool = false
    private var isLoadingMore: Bool = false
    @IBOutlet private(set) var errorView: ErrorView?
    
    var onSelection: (Post) -> Void = { _ in }
    
    private var viewModel: PostListViewModel
   
    init?(viewModel: PostListViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    @available(*, unavailable, renamed: "init(product:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }


    var tableModel = [PostCellController]()
    

    @IBAction private func refresh() {
        viewModel.loadPost()
    }
}

extension PostListViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        if !isViewAppeared{
            refresh()
            isViewAppeared = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sizeTableHeaderToFit()
    }
}

extension PostListViewController{
    func bind() {
        
            title = viewModel.listViewtitle
            viewModel.onLoadingStateChange = { [weak self] isLoading in
                guard let self = self else { return }
                
                if isLoading {
                    self.refreshControl?.beginRefreshing()
                } else {
                    self.refreshControl?.endRefreshing()
                }
            }

            viewModel.onErrorStateChange = { [weak self] errorMessage in
                guard let self = self else { return }
                if let message = errorMessage {
                    self.errorView?.message = message
                } else {
                    self.errorView?.message = nil
                }
            }
       
        
    }
}

extension PostListViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == tableModel.count-1){
            if(tableView.isDragging){
                
                    if(!isLoadingMore && !viewModel.isLast){
                        isLoadingMore = true
                        self.fetchMoreItemsToDisplay()
                    }else{
                        self.hideSpinnerView()
                    }
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = cellController(forRowAt: indexPath).getPostModel()
        onSelection(model)
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> PostCellController {
        return tableModel[indexPath.row]
    }

    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}

extension PostListViewController{
    
    func displayNewlyFetchedItems(_ newItems: [PostCellController]){
        
        if(viewModel.isFirst){
            self.appendItems(newItems)
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.265 ){
                self.insertItems(newItems)
            }
            
        }
       
    }
    
    private func appendItems(_ newItems: [PostCellController]){
       
        tableModel.append(contentsOf: newItems)
        tableView.reloadData()
        isLoadingMore = false
    }
    
    private func insertItems(_ newItems: [PostCellController]){
        if(!newItems.isEmpty){
            
            let updatedCollections = newItems
            
            var insIndices = [IndexPath]()
            var insertions = [PostCellController]()
            
            for item in updatedCollections {
                if(!self.tableModel.contains(item)){
                    let insIndex = self.tableModel.count
                    self.tableModel.insert(item, at: insIndex)
                    insertions.append(item)
                }
            }
            
            for ins in insertions {
                if let index = self.tableModel.firstIndex(of: ins){
                    insIndices.append(IndexPath(row: index, section: 0))
                }
            }
            
            self.tableView?.performBatchUpdates({
                if(!insIndices.isEmpty){
                    self.tableView?.insertRows(at: insIndices, with: .top)
                }
            }, completion: { _ in
                
            })
           
            isLoadingMore = false
        }
    }
}

private extension PostListViewController{
    private func fetchMoreItemsToDisplay(){
        
        showSpinnerView()
        refresh()
    }
    
    private func showSpinnerView(){       
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: 44)
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
       
    }
    
    private func hideSpinnerView(){
            self.tableView.tableFooterView = nil
            self.tableView.tableFooterView?.isHidden = true
       
    }
}
