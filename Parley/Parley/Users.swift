//
//  Users.swift
//  Parley
//
//  Created by Amirul Sunesara on 4/22/17.
//  Copyright © 2017 Amirul Sunesara. All rights reserved.
//
import UIKit
import Foundation
class Users{
 
    var userId : NSString?
    var displayName: NSString?
    var password: NSString?
    var chats : Dictionary<String,String>?
    var isSelected : Bool?
    var picture: UIImage?
    var pic_url: NSString?

    init(userId: NSString?,displayName: NSString?,password: NSString?,chats: Dictionary<String,String>?,isSelected: Bool?,picture: UIImage?,pic_url: NSString?){
        self.userId = userId
        self.displayName = displayName
        self.password = password
        self.chats = chats
        self.isSelected = isSelected
        self.picture = picture
        self.pic_url = pic_url
    }
    func toDict() -> Dictionary<String,AnyObject>{
    
    
        return ["userId":self.userId!,"password":self.password!,"isSelected":false as AnyObject,"displayName":self.displayName!]
    }
    
    
}
