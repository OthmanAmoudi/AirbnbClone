//
//  MapViewController.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 01/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController,CLLocationManagerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    
    var myLongtiude=String()
    var myLatitude=String()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
        
        myLatitude = String(location.coordinate.latitude)
        myLongtiude = String(location.coordinate.longitude)
        
        print(myLatitude)
        print(myLongtiude)
        
        
        
    }
    @IBAction func saveLocation(_ sender: Any) {
        print("MY Location")
        print(myLongtiude)
        print(myLatitude)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate=self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController {
        let destinationVC = navigationController.topViewController as? PostNewRoomViewController
        destinationVC?.latitude = myLatitude
        destinationVC?.longtiude = myLongtiude
        }

}
}
