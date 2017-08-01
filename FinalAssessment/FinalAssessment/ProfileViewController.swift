//
//  ProfileViewController.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 01/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase
import SwiftForms

//import Former
class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    
    var user = [User]()
    let userID = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeUserInfo()
        
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _ = self.tabBarController?.selectedIndex = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func EditProfileDidPressed(_ sender: Any) {
        performSegue(withIdentifier: "ShowEdit", sender: nil)
    }
    @IBAction func Logout(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm", message: "are you sure you want to Log out ?", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        let logout = UIAlertAction(title: "Logout", style: UIAlertActionStyle.default) { (UIAlertAction) in
            print(Auth.auth().currentUser as Any)
            do{
                ProgressHUD.show("logging out...", interaction: false)
                try Auth.auth().signOut()
            } catch let logoutError{
                print(logoutError)
            }
            ProgressHUD.dismiss()
            print(Auth.auth().currentUser as Any)
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(logout)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditProfileViewController
        destinationVC.emailString = emailTextField.text!
        destinationVC.nameString = nameTextField.text!
        destinationVC.imageVariable = profilePicture.image!
    }


    func observeUserInfo(){
        Database.database().reference().child("users").child(userID).observe(.value, with: { (snapshot) in
            if !snapshot.exists() {
                print("No data found")
                return
            }
            
            let dictionary = snapshot.value as? NSDictionary
            let username = dictionary?["username"] as? String?
           // let useremail = dictionary?["email"] as? String?
            let profilePicURL = dictionary?["Profile Picture"] as? String?
            
            self.nameTextField.text = username!
            self.emailTextField.text = Auth.auth().currentUser?.email
            self.profilePicture.downloadImage2(from: profilePicURL!)

        })
    }

}


extension UIImageView {
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                
                self.image = UIImage(data: data!)
                
            }
        }
        task.resume()
    }
    
    func downloadImage2(from imgURL: String!) {
        ProgressHUD.show("loading image...", interaction: false)
        let url = URLRequest(url: URL(string: imgURL)!)
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                
                self.image = UIImage(data: data!)
                ProgressHUD.dismiss()
                
            }
        }
        task.resume()
    }
}
