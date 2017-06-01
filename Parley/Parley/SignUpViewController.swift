//
//  SignUpViewController.swift
//  Parley
//
//  Created by Amirul Sunesara on 4/24/17.
//  Copyright © 2017 Amirul Sunesara. All rights reserved.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var users : Users?
   
   
    
    @IBOutlet var imageView: UIImageView!
    var ref : FIRDatabaseReference!
    var storageRef : FIRStorageReference!
    let metaData = FIRStorageMetadata()
    var imageURL : NSURL!
    var extnsn :String!
    @IBOutlet var txtDisplayName: UITextField!
    override func viewDidLoad() {
    
        super.viewDidLoad()
        imageView.image = nil
         ref = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func chooseImage(_ sender: AnyObject) {
    
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)

    
    
    
    }
    func createAlert(title:String,message:String){
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { action in
            alert.dismiss(animated: true, completion: nil)
            
            
        })
        self.present(alert,animated: true,completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
          
        
            imageView.image=image
            
         
            imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
           extnsn = imageURL.absoluteURL!.pathExtension.lowercased()
            
           
            
    }
        self.dismiss(animated: true, completion: nil)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "completeSignUp"{
            let navController = segue.destination as! UINavigationController
            let chatsViewController = navController.topViewController as! ChatsViewController
            chatsViewController.userId = users?.userId as! String
            
        
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func completeSignUp(_ sender: UIButton) {
        if txtDisplayName.text == ""{
            
            createAlert(title: "" , message: "Please Enter Display Name")
        }
        else if imageView.image == nil
        {
             createAlert(title: "" , message: "Please Select Display Image")
        
        }
        else
        {
             let displayName = txtDisplayName.text! as NSString
          //  let phoneNumber = users?.userId as! String
            users?.displayName = displayName
    
       
            
            self.ref.child("users").child(users?.userId as! String).setValue(users?.toDict())
        
            let photoRef = storageRef.child("profilePictures/"+(users?.userId as! String)+"/\(users!.userId).jpg")
            
        
            let metaDataa = FIRStorageMetadata()
            metaDataa.contentType = "image/jpeg"
            
            
            photoRef.put(UIImageJPEGRepresentation(imageView.image!, 0.8)!, metadata: metaDataa)
            performSegue(withIdentifier: "completeSignUp", sender: nil)
        }
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


