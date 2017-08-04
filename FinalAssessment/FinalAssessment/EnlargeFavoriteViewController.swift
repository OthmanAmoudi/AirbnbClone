//
//  EnlargeFavoriteViewController.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 03/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase
import MapKit
class EnlargeFavoriteViewController: UIViewController {

    @IBOutlet weak var roomPictureContainer: UIImageView!
    
    @IBOutlet weak var date1TF: UITextField!
    @IBOutlet weak var date2TF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descTF: UITextField!
    
    var posIDToRecieve:String! //room ID
    var emailToRecieve:String!
    var nameToRecieve:String!
    var uidToRecieve:String!  //Owner UID
    var dateToRecieve:String!
    var date2ToRecieve:String!
    var titleToRecieve:String!
    var latitudeToRecieve:String!
    var longtitudeToRecieve:String!
    var descriptionToRecieve:String!
    var selectedRoomPicture: UIImage?
    var roomPicToRecieve:UIImage!

    let userID = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        
        date1TF.isUserInteractionEnabled=false
        date2TF.isUserInteractionEnabled=false
        titleTF.isUserInteractionEnabled=false
        descTF.isUserInteractionEnabled=false
        
        
    }
    
    @IBAction func RemoveDidPressed(_ sender: Any) {
        ProgressHUD.showSuccess("Removed From Favorite")
        Database.database().reference().child("rooms").child(posIDToRecieve).child(userID!).removeValue() 
    }
    @IBAction func backDidPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func ViewInMapsDidPressed(_ sender: Any) {
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        titleTF.text = titleToRecieve
        roomPictureContainer.image = roomPicToRecieve
        date1TF.text = dateToRecieve
        date2TF.text = date2ToRecieve
        descTF.text = descriptionToRecieve
        
    }


}
