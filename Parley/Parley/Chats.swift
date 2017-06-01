//
//  Chats.swift
//  Parley
//
//  Created by Amirul Sunesara on 5/17/17.
//  Copyright © 2017 Amirul Sunesara. All rights reserved.
//

import Foundation
import UIKit


class Chats
{

   
    var topic : String?
    var members : Dictionary<String,String>?
    var messages : Dictionary<String,AnyObject>?

    init(topic: String?,members:Dictionary<String,String>?,messages: Dictionary<String,AnyObject>?)
        {
        self.topic = topic
        self.members = members
        self.messages = messages
        }
}
