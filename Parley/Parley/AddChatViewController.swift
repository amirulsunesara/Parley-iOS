//
//  AddChatViewController.swift
//  Parley
//
//  Created by Amirul Sunesara on 4/25/17.
//  Copyright © 2017 Amirul Sunesara. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
class AddChatViewController:UIViewController,UITableViewDelegate,UITableViewDataSource, NVActivityIndicatorViewable{

    @IBOutlet var txtChatName: UITextField!
    var userId : String!
    @IBOutlet var tblChats: UITableView!
    var storageRef : FIRStorageReference!
    var databaseRef : FIRDatabaseReference!
   var arrUsers = Array<Dictionary<String,AnyObject>>()
    var dictChatMembers = Dictionary<String,Int>()
    var dictPhotos = Dictionary<String,AnyObject>()
    var rowCount = 0
    var selectedRowCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        storageRef = FIRStorage.storage().reference()
        databaseRef = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
        self.tblChats.allowsMultipleSelection = true
      
        
        self.databaseRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            self.rowCount = Int(snapshot.childrenCount)-1
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
              
               let dict = (rest.value as! NSDictionary) as! Dictionary<String,AnyObject>
               if(!(dict["userId"]!.isEqual(self.userId!)) )
               {
                let id = dict["userId"]!
                let photoRef = self.storageRef.child("profilePictures/\(id)/\(id)")
                photoRef.data(withMaxSize: 5 * 1024 * 1024) { data, error in
                    if let error = error {
                        
                    } else {
                       
                        let userImage = UIImage(data: data!)
                        self.dictPhotos[id as! String] = userImage
                    let selectedRows = self.tblChats.indexPathsForSelectedRows
                       self.tblChats.reloadData()
                    //tblChats.indexPathsForSelectedRows = selectedRows
                
                        
                if(selectedRows != nil)
                {
                        for select in selectedRows!{
                        self.tblChats.selectRow(at: select, animated: true, scrollPosition: UITableViewScrollPosition.top)
                            
                    
                    
                        
                        }
                        }
                      
                        
                    }
                }
                
               
                self.arrUsers.append(dict)
                }
            }
            print(self.arrUsers)
            self.tblChats.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

    @IBAction func logOut(_ sender: AnyObject) {
        
        let storyboardObj = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboardObj.instantiateInitialViewController() as! LoginViewController
        let delegate =  UIApplication.shared.delegate as! AppDelegate
        
        var logoutAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        logoutAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
             delegate.window?.rootViewController = loginViewController
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(logoutAlert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createAlert(title:String,message:String){
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { action in
            alert.dismiss(animated: true, completion: nil)
            
            
        })
        self.present(alert,animated: true,completion: nil)
        
    }

    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "chatCell"
        let cell = tblChats.dequeueReusableCell(withIdentifier: cellIdentifier) as! AddChatTableViewCell
    cell.lblUserName.text = (arrUsers[indexPath.row]["displayName"] as! String)
    cell.imgUserImage.layer.cornerRadius = 10
    cell.lblPhoneNo = (arrUsers[indexPath.row]["userId"] as! String)
    let id = arrUsers[indexPath.row]["userId"] as! String
    cell.imgUserImage.image = (dictPhotos[id] as? UIImage)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return rowCount
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        selectedRowCount += 1
       print(selectedRowCount)
    
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)  {
        
 
        selectedRowCount -= 1
        print(selectedRowCount)
        
    
        }
    @IBAction func addChat(_ sender: AnyObject) {
        startAnimating()
        if txtChatName.text != "" && selectedRowCount > 0 {
        
        self.databaseRef.child("users").child(userId).child("chats").childByAutoId().setValue(txtChatName.text!)

        let selectedRows = self.tblChats.indexPathsForSelectedRows
            var getUsers = [NSString]()
              let chatName = txtChatName.text!
            var i = 0
            for row in selectedRows!
            {
            
               let currentCell = tblChats.cellForRow(at: row) as! AddChatTableViewCell
                let selectedId = currentCell.lblPhoneNo!
                self.databaseRef.child("users").child(selectedId).child("chats").childByAutoId().setValue(chatName)
                
                getUsers.append(selectedId as NSString)
                i = i + 1
                
            }
           
            self.databaseRef.child("chats").child(chatName).child("members").setValue(getUsers)
        self.databaseRef.child("chats").child(chatName).child("topic").setValue(chatName)
       stopAnimating()
    performSegue(withIdentifier: "chatAdded", sender: nil)

        
        }
        else{
        stopAnimating()
        createAlert(title: "", message: "Please Enter Chat Name or Select People")
 
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatAdded"
        {
            let navController = segue.destination as! UINavigationController
            let chatsViewController = navController.topViewController as! ChatsViewController
            chatsViewController.userId = userId

            

        
        }
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
