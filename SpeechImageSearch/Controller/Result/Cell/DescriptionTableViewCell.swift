//
//  DescriptionTableViewCell.swift
//  SpeechImageSearch
//
//  Created by ChAe on 03/12/2018.
//  Copyright © 2018 ChAe. All rights reserved.
//

import UIKit
import SwiftyAttributes

class DescriptionTableViewCell: UITableViewCell, CellConfig {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var viewHeightLayoutConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Cell Setup Method
    func setup(rowViewModel: RowViewModel) {
        guard let descInfo = rowViewModel as? DescriptionInfo else { return }
        
        descLabel.text = descInfo.desc
        
        self.viewHeightLayoutConstraint.constant = descInfo.tableViewHeight
        
        self.layoutIfNeeded()
    }
}
