//
//  EnlargeMyRoomViewController.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 02/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase
import DatePickerDialog
class EnlargeMyRoomViewController: UIViewController {

    @IBOutlet weak var roomPictureContainer: UIImageView!
    
    @IBOutlet weak var date1TF: UITextField!
    @IBOutlet weak var date2TF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descTF: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
   
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
    
    
    var dateWasChanged = false
    var date2WasChanged = false
    var titleWasChanged = false
    var descWasChanged = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(PostNewRoomViewController.handleImageChosen))
        roomPictureContainer.addGestureRecognizer(tap)
        roomPictureContainer.isUserInteractionEnabled=true
        
        
        handleTextFields()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        titleTF.text = titleToRecieve
        roomPictureContainer.image = roomPicToRecieve
        date1TF.text = dateToRecieve
        date2TF.text = date2ToRecieve
        descTF.text = descriptionToRecieve
        
    }

    @IBAction func saveChangesDidPressed(_ sender: Any) {
        if (dateWasChanged == true){
            Database.database().reference().child("rooms").child(posIDToRecieve).child("Date From").setValue(date1TF.text!)
        }
        if (date2WasChanged == true){
            Database.database().reference().child("rooms").child(posIDToRecieve).child("Date To").setValue(date2TF.text!)
        }
        if (titleWasChanged == true){
            Database.database().reference().child("rooms").child(posIDToRecieve).child("title").setValue(titleTF.text!)
        }
        if (descWasChanged == true){
            Database.database().reference().child("rooms").child(posIDToRecieve).child("description").setValue(descTF.text!)
        }
        
    }
    
    @IBAction func deleteRoomDidPressed(_ sender: Any) {
        ProgressHUD.showSuccess("Room Removed")
        Database.database().reference().child("rooms").child(posIDToRecieve).removeValue()
        _ = navigationController?.popViewController(animated: true)
    }
    func handleTextFields(){
        date1TF.addTarget(self, action: #selector(PostNewRoomViewController.myDateFunction(textField:)), for: UIControlEvents.touchDown)
        date2TF.addTarget(self, action: #selector(PostNewRoomViewController.myDateFunction(textField:)), for: UIControlEvents.touchDown)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func dateDidChanged(_ sender: Any) {
        dateWasChanged = true
    }
    @IBAction func date2DidChanged(_ sender: Any) {
        date2WasChanged = true
    }
    @IBAction func titleDidChanged(_ sender: Any) {
        titleWasChanged = true
    }
    @IBAction func descDidChanged(_ sender: Any) {
        descWasChanged = true
    }
    
    
    func myDateFunction(textField: UITextField) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        DatePickerDialog().show(title: "Chose Date", doneButtonTitle: "Done",
                                cancelButtonTitle: "Cancel", datePickerMode: .date) {
                                    (date) -> Void in
                                    
                                    if date != nil{
                                        let strDate = dateFormatter.string(from:date!)
                                        textField.text = strDate
                                        self.dateWasChanged = true
                                        self.date2WasChanged = true
                                    }else{return}
        }
    }
    
    func handleImageChosen(){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    func sendDataToDatabase(roomPictureUrl:String){
        
        Database.database().reference().child("rooms").childByAutoId().setValue(["title": titleTF.text!,"description": descTF.text!,"Room Picture": roomPictureUrl,"Owner":Auth.auth().currentUser?.uid, "Date From":date1TF.text!,"Date To":date2TF.text!])
    }

}

extension EnlargeMyRoomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            roomPictureContainer.image = image
            selectedRoomPicture = image
            
            ProgressHUD.show("Uploading...", interaction: false)
            if let userPhotoimg =  self.selectedRoomPicture, let imageData = UIImageJPEGRepresentation(userPhotoimg, 0.1){
                let postId = NSUUID().uuidString
                let storageRef = Storage.storage().reference(forURL: "gs://finalassessment-526c0.appspot.com/").child("photos").child(postId)
                
                storageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
                    if error != nil{
                        ProgressHUD.showError(error?.localizedDescription)
                        return
                    }
                    
                    let picUrl = metadata?.downloadURL()?.absoluteString
                    self.updateDataToDatabase(roomPictureUrl: picUrl!)
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
    
    func updateDataToDatabase(roomPictureUrl:String){
        Database.database().reference().child("rooms").child(posIDToRecieve).child("Room Picture").setValue(roomPictureUrl)
        
    }
}
