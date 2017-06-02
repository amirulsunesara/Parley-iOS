//
//  LoginViewController.swift
//  Parley
//
//  Created by Amirul Sunesara on 4/19/17.
//  Copyright © 2017 Amirul Sunesara. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
class LoginViewController: UIViewController,NVActivityIndicatorViewable{

    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtPhoneNumber: UITextField!
    var userId : String!
    var ref : FIRDatabaseReference!

    var refHandle : UInt!
    var newUser : Users?
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
  
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSignUp"{
        let signUpViewController = segue.destination as! SignUpViewController
            signUpViewController.users = newUser
            
        
        
        }
        if segue.identifier == "login"{
            
             let navController = segue.destination as! UINavigationController
            let chatsViewController = navController.topViewController as! ChatsViewController
            chatsViewController.userId = userId
          
         
           
        
        
        }
        
        
        
    }
    
    @IBAction func Login(_ sender: AnyObject) {
        if txtPassword.text != "" && txtPhoneNumber.text != "" {
        startAnimating()
        self.ref.child("users").child(txtPhoneNumber.text!).child("password").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value as? String == self.txtPassword.text!{
                
                self.userId = self.txtPhoneNumber.text!
          self.stopAnimating()
                self.performSegue(withIdentifier: "login", sender: nil)
            }
            else {
                
                
              
              self.createAlert(title: "", message: "Incorrect User Id or Password")
                
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
        else {
        
            self.createAlert(title: "", message: "Please enter Username/Password")
        }
        
        
    }
    
   
    @IBAction func Register(_ sender: UIButton) {
        
        if txtPhoneNumber.text != "" && txtPassword.text != ""{
        startAnimating()
        self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
            if snapshot.hasChild(self.txtPhoneNumber.text!){
                self.stopAnimating()
                self.createAlert(title: "", message: "User Already Exist")
                
            
            }
            else {
                self.stopAnimating()
                self.createUser()
                self.performSegue(withIdentifier: "goToSignUp", sender: nil)
              //  let storyBoardObj = UIStoryboard(name: "Main", bundle: nil)
               // let signUpViewContollerObj = storyBoardObj.instantiateViewController(withIdentifier: "signUpViewController") as! SignUpViewController
               // signUpViewContollerObj.users = self.newUser
                
                // let delegate = UIApplication.shared.delegate as! AppDelegate
                
                 //delegate.window?.rootViewController=signUpViewContollerObj

                
                }
        }) { (error) in
            print(error.localizedDescription)
        }
        }
        else{
        
        self.createAlert(title: "", message: "Please enter Username/Password")
        
        }


    
    }
    func createAlert(title:String,message:String){
    
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { action in
            alert.dismiss(animated: true, completion: nil)
            
        
        })
        self.present(alert,animated: true,completion: nil)
    
    }

    func createUser(){
    
        if txtPhoneNumber.text != "" && txtPassword.text != "" {
            
            let userId = txtPhoneNumber.text! as NSString
            let password = txtPassword.text! as NSString
            newUser = Users(userId: userId, displayName: nil, password: password, chats: nil, isSelected: false, picture: nil, pic_url: nil)
            
            
        //    self.ref.child("users").child(txtPhoneNumber.text!).setValue(newUser.toDict())
            
        }
    
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
