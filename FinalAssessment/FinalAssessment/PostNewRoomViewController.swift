//
//  PostNewRoomViewController.swift
//  
//
//  Created by Othman Mashaab on 01/08/2017.
//
//

import UIKit
import Firebase
import DatePickerDialog
class PostNewRoomViewController: UIViewController {

    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var roomPictureContianer: UIImageView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var date1TF: UITextField!
    @IBOutlet weak var date2TF: UITextField!
    var selectedRoomPicture:UIImage?
    var longtiude=String()
    var latitude=String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PostNewRoomViewController.handleImageChosen))
        roomPictureContianer.addGestureRecognizer(tap)
        roomPictureContianer.isUserInteractionEnabled=true
        
        saveBtn?.isEnabled=false
        handleTextFields()

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
            }else{return}
        }
    }
    
    @IBAction func saveBtnDidPressed(_ sender: Any) {
        
        ProgressHUD.show("Waiting...", interaction: false)
        if let userPhotoimg =  self.selectedRoomPicture, let imageData = UIImageJPEGRepresentation(userPhotoimg, 0.1){
            
                let postId = NSUUID().uuidString
                let storageRef = Storage.storage().reference(forURL: "gs://finalassessment-526c0.appspot.com/" ).child("photos").child(postId)
                storageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
                    if error != nil{
                        ProgressHUD.showError(error?.localizedDescription)
                        return
                    }
                    let roomPictureUrl = metadata?.downloadURL()?.absoluteString
                    self.sendDataToDatabase(roomPictureUrl: roomPictureUrl!)
                    ProgressHUD.showSuccess("Success")
                    self.dismissView()
                })
            }else{
            ProgressHUD.showError("Please select a Photo")
        }

        

        
    }
    @IBAction func backBtn(_ sender: Any) {
        dismissView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        latitudeLabel.text = latitude
        longitudeLabel.text = longtiude
        
        print("didAppear")
        print(longtiude)
        print(latitude)
    }
    

    @IBAction func GetLocationDidPressed(_ sender: Any) {
        performSegue(withIdentifier: "ShowMap", sender: self)
    }
    
    func handleTextFields(){
        titleTextField?.addTarget(self, action: #selector(PostNewRoomViewController.handleTextFieldDidChanged), for: UIControlEvents.editingChanged)
        descriptionTextField?.addTarget(self, action: #selector(PostNewRoomViewController.handleTextFieldDidChanged), for: UIControlEvents.editingChanged)
        date1TF?.addTarget(self, action: #selector(PostNewRoomViewController.handleTextFieldDidChanged), for: UIControlEvents.editingChanged)
        date2TF?.addTarget(self, action: #selector(PostNewRoomViewController.handleTextFieldDidChanged), for: UIControlEvents.editingChanged)
        date1TF.addTarget(self, action: #selector(PostNewRoomViewController.myDateFunction(textField:)), for: UIControlEvents.touchDown)
        date2TF.addTarget(self, action: #selector(PostNewRoomViewController.myDateFunction(textField:)), for: UIControlEvents.touchDown)
    }

    func handleTextFieldDidChanged(){
        guard let title = titleTextField.text, !title.isEmpty, let desc = descriptionTextField.text, !desc.isEmpty,let date1 = date1TF.text, !date1.isEmpty, let date2 = date2TF.text, !date2.isEmpty else {
            saveBtn.tintColor = .red
            saveBtn.isEnabled=false
            return
        }
        saveBtn.tintColor = .blue
        saveBtn.isEnabled=true
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func dismissView(){
        dismiss(animated: true, completion: nil)

    }
    
    func handleImageChosen(){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    func sendDataToDatabase(roomPictureUrl:String){
        
        Database.database().reference().child("rooms").childByAutoId().setValue(["title": titleTextField.text!,"description": descriptionTextField.text!,"Room Picture": roomPictureUrl,"Latitude":latitudeLabel.text,"Longtitude":longitudeLabel.text,"Owner":Auth.auth().currentUser?.uid, "Date From":date1TF.text!,"Date To":date2TF.text!])
    }

}

extension PostNewRoomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            roomPictureContianer.image = image
            selectedRoomPicture = image
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
