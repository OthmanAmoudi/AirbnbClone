//
//  EditProfileViewController.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 01/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class EditProfileViewController: UIViewController {

    
    var selectedProfilePicture: UIImage?
    var passwordTFdidChanged = false
    //var credential: AuthCredential?

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    var emailString = String()
    var nameString = String()
    var imageVariable = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.text = emailString
        nameTF.text = nameString
        profilePicture.image = imageVariable

        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.handleImageChosen))
        profilePicture.addGestureRecognizer(tap)
        profilePicture.isUserInteractionEnabled=true
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SaveDidPressed(_ sender: Any) {
        if (nameTF.text?.isEmpty)! || (emailTF.text?.isEmpty)!{
            ProgressHUD.showError("Please Dont Leave Empty Fields")
            return
        }else{
            
            if emailTF.text != emailString {
                
            Auth.auth().currentUser?.updateEmail(to: emailTF.text!) { (error) in
                    if let error = error{
                        ProgressHUD.showError(error.localizedDescription)
                        print(error.localizedDescription)
                        self.reAuthenticateUser()
                    }else{
                        
                        ProgressHUD.showSuccess("Email Was Updated")
                        print("email was updated")
            Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("email").setValue(self.emailTF.text!)
                }
            }
        } //if curly parentehesis 
           
           
            if(passwordTFdidChanged == true){
            
            Auth.auth().currentUser?.updatePassword(to: passwordTF.text!, completion: { (error) in
                if let error = error {
                    ProgressHUD.showError(error.localizedDescription)
                    print(error.localizedDescription)
                    self.reAuthenticateUser()
                }else{
                    ProgressHUD.showSuccess("Password Was Updated")
                    print("passwprd was updated")
                }
            })
        }
            
    Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("username").setValue(nameTF.text!)
        }
    }
    
    func reAuthenticateUser(){

        let alert = UIAlertController(title: "Confirm", message: "Reuthentication is required, Please Enter your password", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Confirm",style: .default) { action in
        let passwordField = alert.textFields![0]
            
            
        let user = Auth.auth().currentUser
            
        let credential = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email)!, password: passwordField.text!)
            

        //prompt user to re-enter info
        
        user?.reauthenticate(with: credential, completion: { (error) in
            if error != nil
            {
                print("Error reauthenticating user")
                ProgressHUD.showError(error?.localizedDescription)
            }
            else
            {
                ProgressHUD.showSuccess("Reauthentication Success, You Can Edit Your Credential Now")
               // print("Successful reauthentication")
            }
        })
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
      
    
    }
    
    @IBAction func textFieldDidChanged(_ sender: Any) {
        //passwordTextField
        passwordTFdidChanged = true
    }

    @IBAction func BackDidPressed(_ sender: Any) {
        dismissPage()
    }

    func dismissPage(){
        dismiss(animated: true, completion: nil)
    }
    
    func handleImageChosen(){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            profilePicture.image = image
            selectedProfilePicture = image
            
            ProgressHUD.show("Uploading...", interaction: false)
            if let userPhotoimg =  self.selectedProfilePicture, let imageData = UIImageJPEGRepresentation(userPhotoimg, 0.1){
                let postId = NSUUID().uuidString
                let storageRef = Storage.storage().reference(forURL: "gs://finalassessment-526c0.appspot.com/").child("photos").child(postId)
                
                storageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
                    if error != nil{
                        ProgressHUD.showError(error?.localizedDescription)
                        return
                    }
                    
                    let picUrl = metadata?.downloadURL()?.absoluteString
                    self.updateDataToDatabase(profilePictureUrl: picUrl!)
                    ProgressHUD.showSuccess("Sucess")
                })
                
            } else{
                ProgressHUD.showError("Error occur while updating your Photo")
                print("Photos cant be empty")
            }
            
        }

        dismiss(animated: true, completion: nil)
            
    }
    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateDataToDatabase(profilePictureUrl:String){
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("Profile Picture").setValue(profilePictureUrl)
        
    }
}


    
    



