//
//  PasswordTableViewCell.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/12/22.
//

import UIKit

class PasswordTableViewCell: UITableViewCell {

    @IBOutlet weak var passTypeImage: UIImageView!
    @IBOutlet weak var websiteName: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
