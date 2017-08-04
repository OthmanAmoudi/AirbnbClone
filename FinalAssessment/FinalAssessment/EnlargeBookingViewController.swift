//
//  EnlargeBookingViewController.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 04/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase
import MapKit
class EnlargeBookingViewController: UIViewController {

    @IBOutlet weak var ownerEmail: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var roomPicContainer: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var date2Label: UILabel!
    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var ownerPic: UIImageView!
    var posIDToRecieve:String! //room ID
    var emailToRecieve:String!
    var nameToRecieve:String!
    var uidToRecieve:String!  //Owner UID
    var dateToRecieve:String!
    var date2ToRecieve:String!
    var latitudeToRecieve:String!
    var longtitudeToRecieve:String!
    var descriptionToRecieve:String!
    var roomPicToRecieve:UIImage!
    var roomPicURLToRecieve:String!
    var titleToRecieve:String!
    
    var bookingIdToRecieve:String!
    
    let currentUserID = Auth.auth().currentUser?.uid
    
    let userID = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()

        
        observeOwner()
        titleTF.isUserInteractionEnabled=false
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        titleTF.text = titleToRecieve
        roomPicContainer.image = roomPicToRecieve
        dateLabel.text = dateToRecieve
        date2Label.text = date2ToRecieve
        
        
    }
    @IBAction func backDidPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }

    @IBAction func openMapsDidPressed(_ sender: Any) {
        let latConv = Double(latitudeToRecieve)
        let longConv = Double(longtitudeToRecieve)
        let roomCoordinates = CLLocationCoordinate2DMake(latConv!, longConv!)
        let regionDistance:CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegionMakeWithDistance(roomCoordinates, regionDistance, regionDistance)
        let option = [MKLaunchOptionsMapCenterKey :NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey : NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placeMark = MKPlacemark(coordinate: roomCoordinates)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.openInMaps(launchOptions: option)
    }
    @IBAction func cancelBookingDidPressed(_ sender: Any) {
        ProgressHUD.show("Canceling", interaction: false)
        Database.database().reference().child("booking").child(bookingIdToRecieve).removeValue()
        ProgressHUD.showSuccess("Your Booking was Canceled", interaction: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func observeOwner(){
        
        Database.database().reference().child("users").child(uidToRecieve).observe(.value, with: { (snapshot) in
            if !snapshot.exists() {
                print("No data found")
                return
            }
            let dictionary = snapshot.value as? NSDictionary
            let username = dictionary?["username"] as? String?
            let useremail = dictionary?["email"] as? String?
            let profilePicURL = dictionary?["Profile Picture"] as? String?
            
            self.ownerName.text = username!
            self.ownerEmail.text = useremail!
            self.ownerPic.downloadImage(from: profilePicURL!)
        })
        
    }

    

 

}
