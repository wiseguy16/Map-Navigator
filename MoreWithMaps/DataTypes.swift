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

enum Beacon {
    case food(imageName: String)
    case bar
    case shopping
    case services
    case emergency
    case landmark
}
