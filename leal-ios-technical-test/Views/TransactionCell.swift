//
//  TransactionCell.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 8/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var readImage: UIImageView!
    @IBOutlet weak var commerceNameLabel: UILabel!
    @IBOutlet weak var commerceBranchNameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        superview?.layer.cornerRadius = superview!.frame.size.height/5
        superview?.layer.shadowPath = UIBezierPath(rect: superview!.bounds).cgPath
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
