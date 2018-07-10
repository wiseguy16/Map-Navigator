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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return custAnnots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionCell", for: indexPath) as! MyCollectionCell
        let beacon = custAnnots[indexPath.row]
        if let title = beacon.title {
            let appliedStyledWord = applyStyle4(on: title, color: .black, fontSize: 14.0, kernSize: 0.3)
            cell.markerTitle.attributedText = appliedStyledWord
            let descString = title + " is a great place to sit and relax and have a great time with friends."
            let appliedDescrip = applyStyle3(on: descString, color: .darkGray, fontSize: 12.0, kernSize: 0.3)
            cell.markerDescription.attributedText = appliedDescrip

        }
   
        cell.infoButton.backgroundColor = .white
        cell.infoButton.layer.cornerRadius = 4
        cell.infoButton.layer.masksToBounds = true
        
        if let image = beacon.imageName {
            let theImage = UIImage(named: image)
            cell.markerImageView.image = theImage
            cell.markerImageView.layer.cornerRadius = 30
            cell.markerImageView.layer.borderWidth = 1.0
            cell.markerImageView.layer.borderColor = UIColor.darkGray.cgColor
            cell.markerImageView.clipsToBounds = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let annot = custAnnots[indexPath.row]
        myMapView.selectAnnotation(annot, animated: true)

    }

}
