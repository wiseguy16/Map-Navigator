//
//  CustomAnnotat.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 7/30/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
    var beaconName: String!
}

class CustomAnnotat: MKPointAnnotation {
    var locatCoordLat: CLLocationDegrees?
    var locatCoordLong: CLLocationDegrees?
    var imageName: String?
    var beaconName: String?
    var companyName: String?
    var category: String?
    var web: String?
    var beacon: Beacon?
    
    override init() {
        locatCoordLat = 0.0
        locatCoordLong = 0.0
        imageName = ""
        beaconName = ""
        companyName = ""
        category = ""
        web = ""
    }
    
    init(dictionary: [String: AnyObject]) {
        self.companyName = dictionary["title"] as? String
        self.beaconName = dictionary["beaconName"] as? String
        self.imageName = dictionary["imageName"] as? String
        self.locatCoordLat = dictionary["locatCoordLat"] as? CLLocationDegrees
        self.locatCoordLong = dictionary["locatCoordLong"] as? CLLocationDegrees
        self.category = dictionary["category"] as? String
        self.web = dictionary["web"] as? String
        guard let beaconName = self.beaconName else { return }
        self.beacon = Beacon(rawValue: beaconName)
    }
    
}

class StarbucksAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var phone: String!
    var name: String!
    var address: String!
    var image: UIImage!
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
