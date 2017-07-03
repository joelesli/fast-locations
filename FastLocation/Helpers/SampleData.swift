//
//  SampleData.swift
//  FastLocation
//
//  Created by Joel Martinez on 4/24/17.
//  Copyright © 2017 JoelEsli.com. All rights reserved.
//

import UIKit
import MapKit

open class SampleDataObjects : NSObject {
    static let shared = SampleDataObjects()
    
    public var data : [TableDataItem] = SampleData.data()
    public var sortedFavorites = SampleData.data().filter() { $0.isFavorite == true }.sorted { ($0.title ?? "") <= ($1.title ?? "")}
    
    public func toggleFavorite(_ tableDataItem : TableDataItem?) {
        
        guard let tData = tableDataItem else {
            return
        }
        
        var tdi = tData
        tdi.isFavorite = !tData.isFavorite
        if tData.isFavorite {
            //add it
            sortedFavorites.insert(tdi, at: 0)
        }
        else {
            //remove it
            sortedFavorites = sortedFavorites.filter() { $0.title ?? "" != tdi.title ?? "" }
        }
        
    }
    
    public func move(favorite at: Int,to destination: Int) {
        let tbd = sortedFavorites.remove(at: at)
        sortedFavorites.insert(tbd, at: destination)
        
    }
}

/// Demo class to show the methods that need to be implemented 
/// to plug & play your data into the application. 
/// The data class must conform to the TableDataItem and MKAnnotation.
/// Note that the MKAnnotation protocol has been extended.
open class SampleData: NSObject, TableDataItem, MKAnnotation {

    
    // MARK: - MKAnnotation
    public var title : String? = ""
    public var subtitle : String? = ""
    public var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 52.535295, longitude: 13.343144)
    
    // MARK: - MKAnnotation Extension
    public var identifier : String { get { return "city" } }
    public var canShowCallout : Bool = true
    public var hasCalloutAction : Bool = true
    public var pinTintColor : UIColor = UIColor.accentColor()
    
    // MARK: - TableDataItem
    public var image : UIImage? = #imageLiteral(resourceName: "icon_location_filled")
    public var isFavorite: Bool = false
    public var lastUsed: Date?
   
    public var cellImage : UIImage? {
        get {
            return image
        }
        
        set {
            image = newValue
        }
    }
    
    public var cellImageTintColor : UIColor? { get { return UIColor.accentColor()}}
    

    open override var description: String {
        return "\(title ?? "") | \(subtitle ?? "")"
    }
    
    /// Convenience method that creates SampleData objects and returns them as an array of TableDataItem.
    ///
    /// - Returns: An array TableDataItem
    class func data() -> [TableDataItem] {
        
        let berlin = SampleData()
        berlin.title = "Berlin"
        berlin.subtitle = "Capital of Germany"
        berlin.lastUsed = Date().addingTimeInterval(-24*60*60)
        berlin.coordinate = CLLocationCoordinate2D(latitude: 52.535295, longitude: 13.343144)
        
        let munich = SampleData()
        munich.title = "Munich"
        munich.subtitle = "Capital of cars"
        munich.coordinate = CLLocationCoordinate2D(latitude: 48.142914, longitude: 11.552303)
        
        let frankfurt = SampleData()
        frankfurt.title = "Frankfurt"
        frankfurt.subtitle = "Capital of banks"
        frankfurt.isFavorite = true
        frankfurt.coordinate = CLLocationCoordinate2D(latitude: 50.107561, longitude: 8.664436)
        
        return [berlin, munich, frankfurt]
        
    }

}










