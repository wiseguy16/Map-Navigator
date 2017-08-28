//
//  DataTypes.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 8/21/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import Foundation

enum Day {
    case sunday
    case monday
    case tuesday
    case wednesday
    case friday
    case saturday
}

enum BeaconBig {
    case food
    case bar
    case shopping
    case services
    case emergency
    case landmark
}

enum Beacon: String {
    case ambulance = "ambulancePant.png"
    case atm = "ATMpant.png"
    case burger = "burgerPant.png"
    case business = "businessPant.png"
    case purse = "pursePant.png"
    case train = "trainPant.png"
    case clothes = "clothesPant.png"
    case briefcase = "briefcasePant.png"
    case parking = "parkingPant.png"
    case pharmacy = "pharmacyPant.png"
    
}

struct Rectangle {
    var width: Int
    var height: Int
    
    func area() -> Int {
        return width * height
    }
    
    mutating func scaleBy(w: Int, h: Int) {
        width *= w
        height *= h
    }
}
