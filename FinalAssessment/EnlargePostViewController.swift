//
//  EnlargePostViewController.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 01/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import DatePickerDialog

class EnlargePostViewController: UIViewController {

    @IBOutlet weak var dateFromLabel: UILabel!
    @IBOutlet weak var dateToLabel: UILabel!
    @IBOutlet weak var roomPictureContainder: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerEmailLabel: UILabel!
    @IBOutlet weak var ownerPictureContainer: UIImageView!
    
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
    let currentUserID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ownerPictureContainer.layer.cornerRadius = ownerPictureContainer.frame.size.width / 2
        ownerPictureContainer.clipsToBounds = true
        
        observeOwner()
        print("Room")
        print(descriptionToRecieve)
        print(posIDToRecieve)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        descriptionLabel.text = descriptionToRecieve
        roomPictureContainder.image = roomPicToRecieve
        dateFromLabel.text = dateToRecieve
        dateToLabel.text = date2ToRecieve
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backBtnDidPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openInMapsDidPressed(_ sender: Any) {
        
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
    @IBAction func bookDidPressed(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //dateStyle = DateFormatter.Style.medium
        let date1Conv = dateFormatter.date(from: dateToRecieve)
        let date2Conv = dateFormatter.date(from: date2ToRecieve)

        DatePickerDialog().show(title: "Check-in", doneButtonTitle: "Done",
                                cancelButtonTitle: "Cancel", minimumDate: date1Conv!, maximumDate: date2Conv!, datePickerMode: .date) {
            (date) -> Void in
            
            if date != nil{
                let strDate = dateFormatter.string(from:date!)
                //ProgressHUD.showSuccess()
                print(strDate)
                DatePickerDialog().show(title: "Checkout", doneButtonTitle: "Confirm",
                cancelButtonTitle: "Cancel", minimumDate: date1Conv!, maximumDate: date2Conv!,datePickerMode: .date) { (date) -> Void in
                    if date != nil{
                        
                    let endDate = dateFormatter.string(from:date!)
                    ProgressHUD.show("Gathring you booking Details on|\(strDate)| and |\(endDate)|", interaction: false)
                    Database.database().reference().child("booking").childByAutoId().setValue(["roomId":self.posIDToRecieve,"checkin":strDate,"checkout":endDate,"userID":Auth.auth().currentUser?.uid,"title":self.titleToRecieve,"Room Picture":self.roomPicURLToRecieve,"Longtitude":self.longtitudeToRecieve,"latitude":self.latitudeToRecieve])
                        
                    ProgressHUD.showSuccess("Done booking Details on|\(strDate)| and |\(endDate)|")
                    }else{return}
                }
            }else{return}
        }
    }
    @IBAction func addToFavoriteDidPressed(_ sender: Any) {
        ProgressHUD.show("Adding...", interaction: false)
        Database.database().reference().child("rooms").child(posIDToRecieve).updateChildValues([currentUserID!:"Favorite"])
        ProgressHUD.showSuccess("Added To Favorite")
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
            
            self.ownerNameLabel.text = username!
            self.ownerEmailLabel.text = useremail!
            self.ownerPictureContainer.downloadImage(from: profilePicURL!)
        })
    
    }

}
