//
//  PostNewRoomViewController.swift
//  
//
//  Created by Othman Mashaab on 01/08/2017.
//
//

import UIKit
import Firebase
class PostNewRoomViewController: UIViewController {

    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var roomPictureContianer: UIImageView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var dateLabel2: UILabel!
    @IBOutlet weak var datePicker2: UIDatePicker!
    
    var selectedRoomPicture:UIImage?
    var longtiude=String()
    var latitude=String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("didLoad")
        print(longtiude)
        print(latitude)
        
        datePicker.addTarget(self, action: #selector(PostNewRoomViewController.datePickerChanged(datePicker:)), for: UIControlEvents.valueChanged)
        
        datePicker2.addTarget(self, action: #selector(PostNewRoomViewController.datePickerChanged2(datePicker2:)), for: UIControlEvents.valueChanged)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PostNewRoomViewController.handleImageChosen))
        roomPictureContianer.addGestureRecognizer(tap)
        roomPictureContianer.isUserInteractionEnabled=true
        
        saveBtn?.isEnabled=false
        handleTextFields()

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
    }

    func handleTextFieldDidChanged(){
        guard let title = titleTextField.text, !title.isEmpty, let desc = descriptionTextField.text, !desc.isEmpty else {
            saveBtn.tintColor = .red
            saveBtn.isEnabled=false
            return
        }
        saveBtn.tintColor = .blue
        saveBtn.isEnabled=true
    }
    

    func datePickerChanged(datePicker:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        //dateFormatter.timeStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: datePicker.date)
        dateLabel.text = strDate
    }
    
    func datePickerChanged2(datePicker2:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        //dateFormatter.timeStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: datePicker.date)
        dateLabel2.text = strDate
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
        
        Database.database().reference().child("rooms").childByAutoId().setValue(["title": titleTextField.text!,"description": descriptionTextField.text!,"Room Picture": roomPictureUrl,"Latitude":latitudeLabel.text,"Longtitude":longitudeLabel.text,"Date From":dateLabel.text,"Date To":dateLabel2.text,"Owner":Auth.auth().currentUser?.uid])
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
