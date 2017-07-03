//
//  MapViewController.swift
//  FastLocation
//
//  Created by Joel Martinez on 4/24/17.
//  Copyright © 2017 JoelEsli.com. All rights reserved.
//

import UIKit
import MapKit

public extension MKAnnotation {
    public var identifier : String { get { return "pin"} }
    public var canShowCallout : Bool { get {return true}}
    public var hasCalloutAction : Bool { get {return true} }
    public var pinTintColor : UIColor { get  {return UIColor.accentColor() }}
}


class MapViewController: UIViewController, MKMapViewDelegate {

    var data : [MKAnnotation]? = [MKAnnotation]() {
        didSet {
            if let map = viewMap, let d = data {
                map.removeAnnotations(map.annotations)
                map.addAnnotations(d )
            }
            
        }
    }
    
    var selectedMapDataItem : MKAnnotation?
    
    @IBOutlet weak var viewMap : MKMapView?
    @IBOutlet weak var buttonUserLocation: UIButton! {
        didSet {
            buttonUserLocation.tintColor = UIColor.accentColor()
        }
    }
    
    
    class func controller() -> MapViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let map = viewMap, let d = data {
            map.removeAnnotations(map.annotations)
            map.addAnnotations(d)
        }
        
        if let selected = selectedMapDataItem {
            viewMap?.showAnnotations([selected], animated: true)
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            title = "Map"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func showUserLocation(_ sender: UIButton) {
        if let map = viewMap {
//            map.setCenter(map.userLocation.coordinate, animated: true)
            map.showAnnotations([map.userLocation], animated: true)
        }
        
    }

    
    // MARK - Map View Delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //ignore the user annotation
        let userLoc = mapView.userLocation
        if annotation.isEqual(userLoc)  {
            return nil
        }
        
        var view : MKAnnotationView?
        
        view = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier)
        
        if view == nil {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
            pinView.canShowCallout = annotation.canShowCallout
            pinView.pinTintColor = annotation.pinTintColor
            
            if annotation.hasCalloutAction {
                let button = UIButton(type: .detailDisclosure)
                button.tintColor = annotation.pinTintColor
                pinView.rightCalloutAccessoryView = button
            }
            
            view = pinView
            
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let controller = LabelViewController.controller()
        if let item = view.annotation as? TableDataItem {
            controller.tableDataItem = item
            navigationController?.pushViewController(controller, animated: true)
        }
    }
//    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        
//        let controller = LabelViewController.controller()
//        navigationController?.pushViewController(controller, animated: true)
//        
//    }
}
