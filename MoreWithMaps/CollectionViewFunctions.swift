//
//  CollectionViewFunctions.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 8/25/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // USUAL ColltionVIEW STUFF...
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        //
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return custAnnots.count
    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return custAnnots.count
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionCell", for: indexPath) as! MyCollectionCell
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
            cell.markerImageView.image = theImage
            cell.markerImageView.layer.cornerRadius = 30
            cell.markerImageView.layer.borderWidth = 1.0
            cell.markerImageView.layer.borderColor = UIColor.darkGray.cgColor
            cell.markerImageView.clipsToBounds = true
            
            
            
        }
        // Configure the cell...
        
        return cell


    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "AugustaCell", for: indexPath) as! AugustaCell
//        let beacon = custAnnots[indexPath.row]
//        cell.markerTitle.text = beacon.title
//        cell.infoButton.tintColor = .white
//        cell.infoButton.backgroundColor = .white
//        cell.infoButton.layer.cornerRadius = 4
//        cell.infoButton.layer.masksToBounds = true
//        var useColor = UIColor.white
//        
//        if let catColor = beacon.category {
//            switch catColor {
//            case "Food":
//                useColor = pantOrange
//            case "Business":
//                useColor = pantYellow
//            case "Utility":
//                useColor = pantDarkBlue
//            case "Historic":
//                useColor = pantBeige
//            default:
//                print(catColor)
//            }
//            cell.infoButton.backgroundColor = useColor
//        }
//        if let image = beacon.imageName {
//            let ary = image.components(separatedBy: ".")
//            cell.markerDescription.text = ary[0] + ".com"
//            let theImage = UIImage(named: image)
//            cell.imageView?.image = theImage
//            cell.imageView?.layer.cornerRadius = 30
//            cell.imageView?.layer.borderWidth = 1.0
//            cell.imageView?.layer.borderColor = useColor.cgColor
//            cell.imageView?.clipsToBounds = true
//            
//            
//            
//        }
//        // Configure the cell...
//        
//        return cell
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let annot = custAnnots[indexPath.row]
        myMapView.selectAnnotation(annot, animated: true)

    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // tableView.deselectRow(at: indexPath, animated: true)
//        let annot = custAnnots[indexPath.row]
//        myMapView.selectAnnotation(annot, animated: true)
//    }
}

