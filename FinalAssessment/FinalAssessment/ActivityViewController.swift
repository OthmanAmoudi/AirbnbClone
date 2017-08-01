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

    func observeRooms() {
        Database.database().reference().child("rooms").observe(.value, with: { (snapshot) in
            var rooms = snapshot.value as! [String:AnyObject]
            for(_,value) in rooms  {
                if (rooms.popFirst()?.key) != nil{
                   
                    let title = value["title"] as? String
                    let description = value["description"] as? String
                    let roomPictureUrl = value["Room Picture"] as? String
                    let longitude = value["Longtitude"] as? String
                    let latitude = value["Latitude"] as? String
                    let dateFrom = value["Date From"] as? String
                    let dateTo = value["Date To"] as? String
                    let owner = value["Owner"] as? String
                    
                    let myRooms = Room(title: title!, description: description!, roomPicutreURL: roomPictureUrl!, longitude: longitude!, latitude: latitude!, dateFrom: dateFrom!, dateTo: dateTo!, owner: owner!)
                    
                    self.rooms.append(myRooms)
                    self.tableView.reloadData()
                    
                }
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
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("print")
    }
    
    

}
