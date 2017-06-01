//
//  ChatsViewController.swift
//  Parley
//
//  Created by Amirul Sunesara on 4/25/17.
//  Copyright © 2017 Amirul Sunesara. All rights reserved.
//

import UIKit
import Firebase
class ChatsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tblChat: UITableView!
    var storageRef : FIRStorageReference!
    var databaseRef : FIRDatabaseReference!
    var userId : String!
    var rowCount = 0
    var selectedChatId : String!
    var selectedChatName : String!
    var displayName: String!
    var chats = Array<Dictionary<String,String>>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageRef = FIRStorage.storage().reference()
        databaseRef = FIRDatabase.database().reference()
        
        
        
        self.databaseRef.child("users").child(userId).child("chats").observeSingleEvent(of: .value, with: { (snapshot) in
            self.rowCount = Int(snapshot.childrenCount)
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
      
            let value = rest.value as! String
                if let name = rest.key as? String{
                  var chat = [String: String]()
                    chat[name] = value
                    self.chats.append(chat)
                    self.tblChat.reloadData()
                }
                
           
                
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            
        let removeDict = chats[indexPath.row]
        let key = removeDict.first?.key
        self.databaseRef.child("users").child(userId).child("chats").child(key!).removeValue { (error, ref) in
                if error != nil {
                    print("error \(error)")
                }
            }
       
        
        chats.remove(at: indexPath.row)
            rowCount -= 1
            tblChat.reloadData()
        
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddChat"{
        let addChatViewController = segue.destination as! AddChatViewController
            addChatViewController.userId = userId
        
            
        }
        if segue.identifier == "toChatInterface"{
        
            let messageViewController = segue.destination as! MessagesViewController
            var newChat : Chats?
            newChat?.topic = selectedChatName
            
            
            
            messageViewController.senderDisplayName = self.displayName
            messageViewController.senderId = self.userId
            messageViewController.chats = newChat
            messageViewController.topic = selectedChatName
           // messageViewController.chatsRef = self.databaseRef
        
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "chatCell"
        let cell = tblChat.dequeueReusableCell(withIdentifier: cellIdentifier) as! ChatsTableViewCell
        let chat = chats[indexPath.row]
        let chatName = chat.first?.value
        
        cell.txtChatName.text = chatName
        cell.chatId = chat.first?.key
        
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let chat = chats[indexPath.row]
        selectedChatId = chat.first?.key
        selectedChatName = chat.first?.value
        
        self.databaseRef.child("users").child(userId!).child("displayName").observeSingleEvent(of: .value, with: { (snapshot) in
            
           self.displayName = snapshot.value as! String
            self.self.goToChatInterface()
            
        })

        
        
       
      

    }
    func goToChatInterface()
    {
    performSegue(withIdentifier: "toChatInterface", sender: nil)
    
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    return rowCount
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
