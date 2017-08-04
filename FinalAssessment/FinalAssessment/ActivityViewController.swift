//
//  ActivityViewController.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 01/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase
class ActivityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
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
    var rooms = [Room]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Explore"
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "RoomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RoomCell")
        
        observeRooms()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    func observeRooms(){
        Database.database().reference().child("rooms").observe(.value, with: { (snapshot) in
            
            if !snapshot.exists() {
                print("No data found")
                return
            }
            
            var rooms = snapshot.value as! [String:AnyObject]
            let roomKeys = Array(rooms.keys)
            
            for roomKey in roomKeys  {
                
                guard
                    
                    let value = rooms[roomKey] as? [String:AnyObject]
                    
                    else
                {
                    continue
                }
                
                let title = value["title"] as? String
                let description = value["description"] as? String
                let roomPictureUrl = value["Room Picture"] as? String
                let longitude = value["Longtitude"] as? String
                let latitude = value["Latitude"] as? String
                let dateFrom = value["Date From"] as? String
                let dateTo = value["Date To"] as? String
                let owner = value["Owner"] as? String
                
                let myRooms = Room(roomID: roomKey,title: title!, description: description!, roomPicutreURL: roomPictureUrl!, longitude: longitude!, latitude: latitude!, dateFrom: dateFrom!, dateTo: dateTo!, owner: owner!)

                self.rooms.append(myRooms)
                self.tableView.reloadData()
                
                
                
            }
        })
    
    }
//    func observeRooms() {
//        Database.database().reference().child("rooms").observe(.value, with: { (snapshot) in
//            print()
//            
//            var rooms = snapshot.value as! [String:AnyObject]
//            let dictValues = [String](snapshot.keys)
//            
//            for(_,value) in rooms  {
//             //print(rooms.popFirst()?.key)
//                if (rooms.popFirst()?.key) != nil{
//                   
//                    
//                    
//                    print(dictValues[0]) //Output -- Kqwewsds12
//                    
//                    let title = value["title"] as? String
//                    let description = value["description"] as? String
//                    let roomPictureUrl = value["Room Picture"] as? String
//                    let longitude = value["Longtitude"] as? String
//                    let latitude = value["Latitude"] as? String
//                    let dateFrom = value["Date From"] as? String
//                    let dateTo = value["Date To"] as? String
//                    let owner = value["Owner"] as? String
//                    
//                    let myRooms = Room(roomID: "XXX",title: title!, description: description!, roomPicutreURL: roomPictureUrl!, longitude: longitude!, latitude: latitude!, dateFrom: dateFrom!, dateTo: dateTo!, owner: owner!)
//                    
//                    
//                    print()
//                    self.rooms.append(myRooms)
//                    self.tableView.reloadData()
//                 //   print((snapshot.value as AnyObject).allKeys)
//                   
//                    
//                }
//            }
//        })
//        
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomTableViewCell
       
        cell.titleLabelCell.text = rooms[indexPath.row].title
        cell.dateLabelCell.text = rooms[indexPath.row].dateFrom
        cell.date2LabelCell.text = rooms[indexPath.row].dateTo
        cell.RoomPicCell.downloadImage(from: rooms[indexPath.row].roomPicutreURL)
        cell.latitude = rooms[indexPath.row].latitude
        cell.longitude = rooms[indexPath.row].longitude
        cell.owner = rooms[indexPath.row].owner
        cell.roomDescription = rooms[indexPath.row].description
        cell.roomId = rooms[indexPath.row].roomID
        cell.roomPicURL = rooms[indexPath.row].roomPicutreURL
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! RoomTableViewCell
        
        descriptionToPass = currentCell.roomDescription
        roomPicToPass = currentCell.RoomPicCell.image
        dateToPass = currentCell.dateLabelCell.text
        date2ToPass = currentCell.date2LabelCell.text
        longtitudeToPass = currentCell.longitude
        latitudeToPass = currentCell.latitude
        uidToPass = currentCell.owner
        roomIdToPass = currentCell.roomId
        roomPicURLToPass = currentCell.roomPicURL
        titleToPass = currentCell.titleLabelCell.text
        performSegue(withIdentifier: "EnlargePost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController {
            let destinationVC = navigationController.topViewController as? EnlargePostViewController
           
            destinationVC?.uidToRecieve = uidToPass
            destinationVC?.dateToRecieve = dateToPass
            destinationVC?.date2ToRecieve = date2ToPass
            destinationVC?.posIDToRecieve = roomIdToPass
            destinationVC?.roomPicToRecieve = roomPicToPass
            destinationVC?.latitudeToRecieve = latitudeToPass
            destinationVC?.longtitudeToRecieve = longtitudeToPass
            destinationVC?.descriptionToRecieve = descriptionToPass
            destinationVC?.roomPicURLToRecieve = roomPicURLToPass
            destinationVC?.titleToRecieve = titleToPass
            
        }
    }
    

}


