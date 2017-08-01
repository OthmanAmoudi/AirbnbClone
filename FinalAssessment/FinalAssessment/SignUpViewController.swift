//
//  SignUpViewController.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 01/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class SignUpViewController: UIViewController {

    var selectedProfilePicture: UIImage?
    @IBOutlet weak var ProfilePictureContainer: UIImageView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfilePictureContainer.layer.cornerRadius = ProfilePictureContainer.frame.size.width / 2
        ProfilePictureContainer.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleImageChosen))
        ProfilePictureContainer.addGestureRecognizer(tap)
        ProfilePictureContainer.isUserInteractionEnabled=true
        
        signUpBtn?.isEnabled=false
        handleTextFields()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerDidPressed(_ sender: Any) {
       
        ProgressHUD.show("Waiting...", interaction: false)
        if let userPhotoimg =  self.selectedProfilePicture, let imageData = UIImageJPEGRepresentation(userPhotoimg, 0.1){
            
            Auth.auth().createUser(withEmail: self.emailTF.text!, password: self.passwordTF.text!) { (User, Error) in
                let postId = NSUUID().uuidString
                let storageRef = Storage.storage().reference(forURL: "gs://finalassessment-526c0.appspot.com/" ).child("photos").child(postId)
                storageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
                    if error != nil{
                        ProgressHUD.showError(error?.localizedDescription)
                        return
                    }
                    let profilePictureUrl = metadata?.downloadURL()?.absoluteString
                    self.sendDataToDatabase(profilePictureUrl: profilePictureUrl!)
                    ProgressHUD.showSuccess("Success")
                    self.dismissView()
                })
                
                if Error == nil {
                    ProgressHUD.showSuccess("Please Log-in Now")
                    return
                }
                    
                else if Error != nil {
                    let errorMsg = Error?.localizedDescription
                    let errorAlert = UIAlertController(title: "Error", message: errorMsg!, preferredStyle: .alert)
                    let errorAlertOkayAction = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
                    errorAlert.addAction(errorAlertOkayAction)
                    self.present(errorAlert, animated: true, completion: nil)
                    
                }
            }

            
        } else{
            ProgressHUD.showError("Please select a Photo")
        }

    }

    @IBAction func backDidPressed(_ sender: Any) {
        dismissView()
    }
    
    func dismissView(){
        dismiss(animated: true, completion: nil)

    }
    
    func handleImageChosen(){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextFields(){
        usernameTF?.addTarget(self, action: #selector(SignUpViewController.handleTextFieldDidChanged), for: UIControlEvents.editingChanged)
        passwordTF?.addTarget(self, action: #selector(SignUpViewController.handleTextFieldDidChanged), for: UIControlEvents.editingChanged)
        emailTF?.addTarget(self, action: #selector(SignUpViewController.handleTextFieldDidChanged), for: UIControlEvents.editingChanged)
    }
    
    func handleTextFieldDidChanged(){
        guard let username = usernameTF.text, !username.isEmpty, let email = emailTF.text, !email.isEmpty, let password = passwordTF.text, !password.isEmpty else {
            signUpBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
            signUpBtn.isEnabled=false
            return
        }
        
        signUpBtn.setTitleColor( .black , for: UIControlState.normal)
        signUpBtn.isEnabled=true
    }

}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            ProfilePictureContainer.image = image
            selectedProfilePicture = image
           
        }
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func sendDataToDatabase(profilePictureUrl:String){
    Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).setValue(["username": usernameTF.text!,"email": emailTF.text!,"Profile Picture": profilePictureUrl])
        
        
    }

    
}
