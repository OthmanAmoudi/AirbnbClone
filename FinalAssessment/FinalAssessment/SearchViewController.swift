//
//  SearchViewController.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 03/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating {
    
    
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
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!

    var roomsArray = [NSDictionary?]()
    var filtredRooms = [NSDictionary?]()
    var keys = [String]()
    
    var databaseRef = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()

        databaseRef.child("rooms").queryOrdered(byChild: "title").observe(.childAdded , with: { (snapshot) in
            
            if !snapshot.exists() {
                print("No data found")
                return
            }
            print("#######")
            self.keys.append(snapshot.key)
            self.roomsArray.append(snapshot.value as? NSDictionary)
            self.tableView.insertRows(at: [IndexPath(row:self.roomsArray.count-1,section: 0)], with: UITableViewRowAnimation.automatic)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return filtredRooms.count
        }
        else{
            return self.roomsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let room:NSDictionary?
        if searchController.isActive && searchController.searchBar.text != ""{
            room =  filtredRooms[indexPath.row]
        }
        else{
            room = roomsArray[indexPath.row]
        }
        


        cell.posIdCell = keys[indexPath.row]
        cell.nameLblCell?.text = room?["title"] as? String
        cell.emailLblCell?.text = room?["description"] as? String
        cell.profilePictureCell?.downloadImage(from: room?["Room Picture"] as? String)
        cell.roomPictureURLCell = room?["Room Picture"] as? String
        cell.latitudeCell = room?["Latitude"] as? String
        cell.longitudeCell = room?["Longtitude"] as? String
        cell.date = room?["Date From"] as? String
        cell.date2 = room?["Date To"] as? String
        cell.ownerCell = room?["Owner"] as? String
        
        
       // Database.database().reference().child("rooms").queryOrdered(byChild: currentUser!).queryEqual(toValue:"Favorite").observeSingleEv

        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
    }
    
    func filterContent(searchText:String){
        self.filtredRooms = self.roomsArray.filter({ (room) -> Bool in
            let roomTitle = room!["title"] as? String
            return (roomTitle?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! TableViewCell
        
        descriptionToPass = currentCell.emailLblCell?.text
        dateToPass = currentCell.date
        date2ToPass = currentCell.date2
        roomIdToPass = currentCell.posIdCell
        roomPicToPass = currentCell.profilePictureCell.image
        uidToPass = currentCell.ownerCell
        latitudeToPass = currentCell.latitudeCell
        longtitudeToPass = currentCell.longitudeCell
        
        roomIdToPass = currentCell.posIdCell
        
        performSegue(withIdentifier: "EnlargeRoomSearch", sender: self)
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
            
        }
    }


}
