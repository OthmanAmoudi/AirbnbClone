//
//  ProfileViewController.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 01/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var roomsArray = [NSDictionary?]()

    var roomIdToPass:String!
    var emailToPass:String!
    var nameToPass:String!
    var uidToPass:String! //owner id
    var dateToPass:String!
    var date2ToPass:String!
    var latitudeToPass:String!
    var longtitudeToPass:String!
    var descriptionToPass:String!
    var roomPicURLToPass:String!
    var titleToPass:String!
    var roomPicToPass:UIImage!
    var bookingIdToPass:String!
    
    let currentUser = Auth.auth().currentUser?.uid
    var rooms = [Room]()
    var booking = [Booking]()
    var user = [User]()
    let userID = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeUserInfo()
        
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "BookingTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
  
        observeBooking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  _ = self.tabBarController?.selectedIndex = 1
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func observeBooking(){
        Database.database().reference().child("booking").queryOrdered(byChild:"userID").queryEqual(toValue:currentUser!).observeSingleEvent(of: .value , with: { (snapshot) in
            
            if !snapshot.exists() {
                print("No data found")
                return
            }
            var bookings = snapshot.value as! [String:AnyObject]
            let bookingKeys = Array(bookings.keys)
            for bookingKey in bookingKeys  {
                guard
                    let value = bookings[bookingKey] as? [String:AnyObject]
                    else{continue}
            
            let checkin = value["checkin"] as? String
            let checkout = value["checkout"] as? String
            let roomId = value["roomId"] as? String
            let userID = value["userID"] as? String
            let title = value["title"] as? String
            let roomPicURL = value["Room Picture"] as? String
            let latitude = value["latitude"] as? String
            let longtitude = value["Longtitude"] as? String
                
            let myBooking = Booking(bookingID: bookingKey, checkin: checkin!, checkout: checkout!, roomId: roomId!, userID: userID!, title: title!,roomPicURL:roomPicURL!, latitude: latitude!, longtitude: longtitude!)
            self.booking.append(myBooking)
            
            self.tableView.reloadData()
                
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booking.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookingTableViewCell
        
        cell.dateLabel.text = booking[indexPath.row].checkin
        cell.date2Label.text = booking[indexPath.row].checkout
        cell.titleLabel.text = booking[indexPath.row].title
        cell.roomPicContainer.downloadImage(from: booking[indexPath.row].roomPicURL)
        cell.latitudeCell = booking[indexPath.row].latitude
        cell.longitudeCell = booking[indexPath.row].longtitude
        cell.ownerCell = booking[indexPath.row].userID
        cell.posIdCell = booking[indexPath.row].roomId
        cell.bookingIdCell = booking[indexPath.row].bookingID
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! BookingTableViewCell
        
        roomPicToPass = currentCell.roomPicContainer.image
        latitudeToPass = currentCell.latitudeCell
        longtitudeToPass = currentCell.longitudeCell
        uidToPass = currentCell.ownerCell
        roomIdToPass = currentCell.posIdCell
        titleToPass = currentCell.titleLabel.text
        bookingIdToPass = currentCell.bookingIdCell
        dateToPass = currentCell.dateLabel.text
        date2ToPass = currentCell.date2Label.text
        performSegue(withIdentifier: "EnlargeBooking", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if (segue.identifier == "EnlargeBooking"){
            if let navigationController = segue.destination as? UINavigationController {
            let destinationVC = navigationController.topViewController as? EnlargeBookingViewController
                
            destinationVC?.titleToRecieve = titleToPass
            destinationVC?.uidToRecieve = uidToPass
            destinationVC?.dateToRecieve = dateToPass
            destinationVC?.date2ToRecieve = date2ToPass
            destinationVC?.posIDToRecieve = roomIdToPass
            destinationVC?.roomPicToRecieve = roomPicToPass
            destinationVC?.latitudeToRecieve = latitudeToPass
            destinationVC?.longtitudeToRecieve = longtitudeToPass
            destinationVC?.bookingIdToRecieve = bookingIdToPass
        }
    }
        if (segue.identifier == "ShowEdit"){
                let destination2VC = segue.destination as! EditProfileViewController
                destination2VC.emailString = emailTextField.text!
                destination2VC.nameString = nameTextField.text!
                destination2VC.imageVariable = profilePicture.image!
        }    
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destinationVC = segue.destination as! EditProfileViewController
//        destinationVC.emailString = emailTextField.text!
//        destinationVC.nameString = nameTextField.text!
//        destinationVC.imageVariable = profilePicture.image!
//    }


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
