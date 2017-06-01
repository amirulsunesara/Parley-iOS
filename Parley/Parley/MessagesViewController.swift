//
//  MessagesViewController.swift
//  Parley
//
//  Created by Amirul Sunesara on 5/17/17.
//  Copyright © 2017 Amirul Sunesara. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController



class MessagesViewController: JSQMessagesViewController{
    
    var topic : String!
    var chats: Chats? {
        didSet {
            title =  chats?.topic
            topic = title
        }
    }
    
    
    var messageRef: FIRDatabaseReference!
    private var newMessageRefHandle: FIRDatabaseHandle?
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    var messages = [JSQMessage]()
    
   

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageRef = FIRDatabase.database().reference()
     
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
          observeMessages()
        // Do any additional setup after loading the view.
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    private func addMessage(withId id: String, name: String, text: String, timeStamp: Date) {
        if let message = JSQMessage(senderId: id, senderDisplayName: name, date: timeStamp, text: text)
        {
            
            messages.append(message)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let chatsRef = messageRef.child("chats").child(topic!).child("messages")
        let itemRef = chatsRef.childByAutoId() // 1
        let dateFormatter = DateFormatter()
        let date = Date()
        
        // US English Locale (en_US)
   
        dateFormatter.dateFormat = "MMM,d hh:mm a"
       

        
        
        let messageItem = [ // 2
            "from": senderId!,
            "displayName": senderDisplayName!,
            "message": text!,
            "timestamp" : dateFormatter.string(from: date)
            
            ]
        
        itemRef.setValue(messageItem) // 3
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        
        finishSendingMessage() // 5
    }
    
    
    private func observeMessages() {
        let chatsRef = messageRef.child("chats").child(topic!).child("messages")
        // 1.
        let messageQuery = chatsRef.queryLimited(toLast:25)
        
        // 2. We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            // 3
            let messageData = snapshot.value as! Dictionary<String, AnyObject>
            
            if let id = messageData["from"] as! String!, let name = messageData["displayName"] as! String!, let text = messageData["message"] as! String!, let dateData = messageData["timestamp"] as! String!, text.characters.count > 0 {
                // 4
                let dateFormatter = DateFormatter()
                
                
                // US English Locale (en_US)
                
                dateFormatter.dateFormat = "MMM,d hh:mm a"
                
                
                let date = dateFormatter.date(from: dateData)
                
                self.addMessage(withId: id, name: name, text: text, timeStamp: date!)
               // self.add
                
                // 5
                self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
        })
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let message = messages[indexPath.item]
        
        let date = message.date!
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM,d hh:mm a"
        
        

        
        return NSAttributedString(string: "\(message.senderDisplayName!) (\(dateFormatter.string(from: date)))")
            
        
        
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 13
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
