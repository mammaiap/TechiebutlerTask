//
//  PostDetailViewController.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//

import UIKit

class PostDetailViewController: UIViewController {
    @IBOutlet private(set) var containerView: UIView!
    @IBOutlet private(set) var userIdLabel: UILabel!
    @IBOutlet private(set) var idLabel: UILabel!
    @IBOutlet private(set) var titleLabel: UILabel!
    @IBOutlet private(set) var bodyLabel: UILabel!
    
    private let viewModel: PostDetailViewModel
    
    init?(viewModel: PostDetailViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    @available(*, unavailable, renamed: "init(product:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        
    }
    
    private func bind(){
        title = viewModel.viewTitle
        self.userIdLabel.text = viewModel.userId
        self.idLabel.text = viewModel.id
        self.titleLabel.text = viewModel.title
        self.bodyLabel.text = viewModel.body
    }
    
    private func setupUI(){
        self.containerView.layer.cornerRadius = 10.0
        self.containerView.layer.masksToBounds = false
        self.containerView.layer.shadowColor = UIColor.lightGray.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.containerView.layer.shadowOpacity = 0.8
        self.containerView.layer.shadowRadius = 5.0
        
    }
    
}



