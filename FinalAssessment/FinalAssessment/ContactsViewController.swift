//
//  ContactsViewController.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 01/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase
class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //not a textfield but a label 
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var senderDisplayName: String?
    var users = [User]()
    var currentUser = [User]()
    
    var emailToPass:String!
    var nameToPass:String!
    var uidToPass:String!
    var picToPass:UIImage!
    
    var currentUserName:String!
    var currentUserPicVar:UIImage!
    let userID = Auth.auth().currentUser!.uid

    // private lazy var userRef: DatabaseReference = Database.database().reference().child("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        observeUserInfo()
        observeUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func observeUserInfo(){
        Database.database().reference().child("users").child(userID).observe(.value, with: { (snapshot) in
            if !snapshot.exists() {
                print("No data found")
                return
            }
            
            let dictionary = snapshot.value as? NSDictionary
            let username = dictionary?["username"] as? String?
            let profilePicURL = dictionary?["Profile Picture"] as? String?
            
            self.nameTextField.text = username!
            self.profilePicture.downloadImage(from: profilePicURL!)
            
        })
    }

    
    func observeUsers() {
       
        Database.database().reference().child("users").observe(.value, with: { (snapshot) in
            var users = snapshot.value as! [String:AnyObject]
            for(_,value) in users  {
            if let user = users.popFirst()?.key{
                    let name = value["username"] as? String
                    let profilepic = value["Profile Picture"] as? String
                    let email = value["email"] as? String
                    let myusers = User(id: user, name: name!, email: email!, proPicURL: profilepic!)
                    self.users.append(myusers)
                    self.tableView.reloadData()
                
                }
            }
      })
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // 2
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
    //    labelHolder.text = currentUserName
        
       // cell.labelHolderForCurrentUser.text = currentUserName
        //nameTextField.text = currentUserName
        
        cell.userIdCell = users[indexPath.row].id
        cell.nameLblCell.text = users[indexPath.row].name
        cell.emailLblCell.text = users[indexPath.row].email
        cell.profilePictureCell.downloadImage(from: users[indexPath.row].proPicURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! TableViewCell
        
        
        nameToPass = currentCell.nameLblCell.text
        emailToPass = currentCell.emailLblCell.text
        uidToPass = currentCell.userIdCell
        picToPass = currentCell.profilePictureCell.image
        self.performSegue(withIdentifier: "ShowChatView", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let navigationController = segue.destination as? UINavigationController {
//            let destinationVC = navigationController.topViewController as? ChatViewController
//            destinationVC?.reciverEmail = emailToPass
//            destinationVC?.reciverImageVariable = picToPass
//            destinationVC?.reciverName = nameToPass
//            destinationVC?.reciverUid = uidToPass
//            // not a text field but a label to pass the data
//            destinationVC?.currUserName = nameTextField.text!
//            destinationVC?.currUserImageVariable = profilePicture.image!
//        }
//    }
}
