//
//  PostCell.swift
//  TechiebutlerTask
//
//  Created by Muthulingam on 28/04/24.
//
//

import Foundation
import UIKit

final class PostCell: UITableViewCell {
    
    @IBOutlet private(set) var idLabel: UILabel!
    @IBOutlet private(set) var titleLabel: UILabel!
    @IBOutlet private(set) var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.cornerRadius = 7.0
        cellView.layer.masksToBounds = false
        cellView.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.25).cgColor
        cellView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cellView.layer.shadowOpacity = 1.0
        cellView.layer.shadowRadius = 3.0
        
        
    }
}
