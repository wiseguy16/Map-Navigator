//
//  TableViewFunctions.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 8/9/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // USUAL TABLEVIEW STUFF...
    func numberOfSections(in tableView: UITableView) -> Int {
        //
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return custAnnots.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AugustaCell", for: indexPath) as! AugustaCell
        let beacon = custAnnots[indexPath.row]
        cell.markerTitle.text = beacon.title
        cell.infoButton.tintColor = .white
        cell.infoButton.backgroundColor = .white
        cell.infoButton.layer.cornerRadius = 4
        cell.infoButton.layer.masksToBounds = true
        var useColor = UIColor.white

        if let catColor = beacon.category {
            switch catColor {
            case "Food":
                useColor = pantOrange
            case "Business":
                useColor = pantYellow
            case "Utility":
                useColor = pantDarkBlue
            case "Historic":
                useColor = pantBeige
            default:
                print(catColor)
            }
            cell.infoButton.backgroundColor = useColor
        }
        if let image = beacon.imageName {
            let ary = image.components(separatedBy: ".")
            cell.markerDescription.text = ary[0] + ".com"
            let theImage = UIImage(named: image)
            cell.imageView?.image = theImage
            cell.imageView?.clipsToBounds = true
        }
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tableView.deselectRow(at: indexPath, animated: true)
        let annot = custAnnots[indexPath.row]
        myMapView.selectAnnotation(annot, animated: true)
    }
}

