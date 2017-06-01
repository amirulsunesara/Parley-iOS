//
//  AddChatTableViewCell.swift
//  Parley
//
//  Created by Amirul Sunesara on 4/25/17.
//  Copyright © 2017 Amirul Sunesara. All rights reserved.
//

import UIKit

class AddChatTableViewCell: UITableViewCell {

    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var imgUserImage: UIImageView!
    @IBOutlet var lblPhoneNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
