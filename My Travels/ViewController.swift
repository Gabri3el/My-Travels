//
//  ViewController.swift
//  My Travels
//
//  Created by Gabriel on 25/08/21.
//

import UIKit
import MapKit


class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var Map: MKMapView!
    var managerLocation = CLLocationManager()
    var travel: Dictionary<String, String> = [:]
    var indiceSelect: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            if indiceSelect == -1 { //add
                configManagerLocation();

            }else{// list
                showAnnotation( travel: travel )
            }
        
        
        let recognizedFinger = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.marked(gesture:)))
        recognizedFinger.minimumPressDuration = 1
        
        Map.addGestureRecognizer(recognizedFinger)
    }
    
    func showAnnotation(travel: Dictionary<String,String>){
        if let localTravel = travel["Local"]{
            if let latitude = travel["latitude"]{
                if let longitude = travel["Longitude"]{
                    //annotation
                    let annotation = MKPointAnnotation()
                    annotation.coordinate.latitude = Double(latitude)!
                    annotation.coordinate.longitude = Double(longitude)!
                    annotation.title = localTravel
                    annotation.subtitle = "I'm here"
                    self.Map.addAnnotation(annotation)
                    
                    //showUser
                    let localization = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    
                    let region: MKCoordinateRegion = MKCoordinateRegion(center: localization, span: span)
                    self.Map.setRegion(region, animated: true)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        let localization = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: localization, span: span)
        self.Map.setRegion(region, animated: true)
        
    }
    
    
    
    @objc func marked(gesture: UIGestureRecognizer){
        if gesture.state == UIGestureRecognizer.State.began{
            let pointSelect = gesture.location(in: self.Map)
            let cordinates = Map.convert(pointSelect, toCoordinateFrom: Map)
            let location = CLLocation(latitude: cordinates.latitude, longitude: cordinates.longitude)
            var completeLocal = "Andress not found"
            //recovery andress
            CLGeocoder().reverseGeocodeLocation(location) { (local, error) in
                if error == nil {
                    if let dataLocal = local?.first{
                        if let name = dataLocal.name{
                             completeLocal = name
                        }else{
                            if let andress = dataLocal.thoroughfare{
                             completeLocal = andress
                            }
                        }
                    }
                    //save
                    
                    self.travel = ["Local":completeLocal, "latitude": String(cordinates.latitude), "Longitude": String(cordinates.longitude)]
                    
                    StorageData().Save(travel: self.travel)
                    
                    
                    
                    //annotation
                    let annotation = MKPointAnnotation()
                    annotation.coordinate.latitude = cordinates.latitude
                    annotation.coordinate.longitude = cordinates.longitude
                    annotation.title = completeLocal
                    annotation.subtitle = "I'm here"
                    self.Map.addAnnotation(annotation)
                    
                    
                }else{
                    print(error!)
                }
            }
            

        }
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse{
            let alertController = UIAlertController(title: "Authotization", message: "Necessary Authotization to use you location", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "Confirm", style: .default) { alertconfig in
                if let config = NSURL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(config as URL)
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alertController.addAction(confirm)
            alertController.addAction(cancel)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func configManagerLocation(){
        managerLocation.delegate = self
        managerLocation.desiredAccuracy = kCLLocationAccuracyBest
        managerLocation.requestWhenInUseAuthorization()
        managerLocation.startUpdatingLocation()
    }

}

