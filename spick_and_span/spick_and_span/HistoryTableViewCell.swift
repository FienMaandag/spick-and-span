//
//  HistoryTableViewCell.swift
//  spick_and_span
//
//  Created by Fien Maandag on 20-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
