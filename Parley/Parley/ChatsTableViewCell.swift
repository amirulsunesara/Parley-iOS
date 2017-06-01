//
//  ChatsTableViewCell.swift
//  Parley
//
//  Created by Amirul Sunesara on 5/6/17.
//  Copyright © 2017 Amirul Sunesara. All rights reserved.
//

import UIKit

class ChatsTableViewCell: UITableViewCell {

    @IBOutlet var txtChatName: UILabel!
    var chatId : String!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
