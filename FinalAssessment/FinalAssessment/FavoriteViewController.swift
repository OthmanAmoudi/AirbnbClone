//
//  FavoriteViewController.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 01/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase
class FavoriteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!

    
    var roomIdToPass:String!
    var emailToPass:String!
    var nameToPass:String!
    var uidToPass:String! //owner id
    var titleToPass=String()
    var dateToPass:String!
    var date2ToPass:String!
    var latitudeToPass:String!
    var longtitudeToPass:String!
    var descriptionToPass:String!
    
    var roomPicToPass:UIImage!
    var rooms = [Room]()
    
    let currentUser = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "RoomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RoomCell")
        observeFavorite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func observeFavorite(){
              Database.database().reference().child("rooms").queryOrdered(byChild: currentUser!).queryEqual(toValue:"Favorite").observeSingleEvent(of: .value, with: { (snapshot) in
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
       //         let key2 = value["key"] as? String
                let myRooms = Room(roomID: roomKey,title: title!, description: description!, roomPicutreURL: roomPictureUrl!, longitude: longitude!, latitude: latitude!, dateFrom: dateFrom!, dateTo: dateTo!, owner: owner!)
                
                self.rooms.append(myRooms)
                self.tableView.reloadData()
                
                print("@@@@")
                print(snapshot.value)
                
            }
        })
        
    }
    
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
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! RoomTableViewCell
        
        titleToPass = currentCell.titleLabelCell.text!
        descriptionToPass = currentCell.roomDescription
        roomPicToPass = currentCell.RoomPicCell.image
        dateToPass = currentCell.dateLabelCell.text
        date2ToPass = currentCell.date2LabelCell.text
        longtitudeToPass = currentCell.longitude
        latitudeToPass = currentCell.latitude
        uidToPass = currentCell.owner
        roomIdToPass = currentCell.roomId
        print("@@@")
        print(titleToPass)
        performSegue(withIdentifier: "EnlargeRoom", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! EnlargeFavoriteViewController
        destinationVC.uidToRecieve = uidToPass
        destinationVC.dateToRecieve = dateToPass
        destinationVC.date2ToRecieve = date2ToPass
        destinationVC.posIDToRecieve = roomIdToPass
        destinationVC.roomPicToRecieve = roomPicToPass
        destinationVC.titleToRecieve = titleToPass
        destinationVC.descriptionToRecieve = descriptionToPass
        destinationVC.latitudeToRecieve = latitudeToPass
        destinationVC.longtitudeToRecieve = longtitudeToPass
    }

   
    



}
