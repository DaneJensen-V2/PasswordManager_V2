//
//  WebsiteTableViewCell.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/14/22.
//

import UIKit

class WebsiteTableViewCell: UITableViewCell {

    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var websiteImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


