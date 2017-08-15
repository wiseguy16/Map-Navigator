//
//  HelperFunctions.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 8/6/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

extension ViewController {
    func hideTable() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.tableViewHeight.constant = 0.0
            //sender.setImage(self.downArrow!, for: .normal)
            // sender.setTitle("Show", for: .normal)
            self.view.layoutIfNeeded()
        }
        isTableHidden = !isTableHidden
        
    }
    
    // HELPER FUNCTIONS FOR ADDING/ REMOVING COMPANIES
    func filterAnnotRemove(with category: String, annots: [CustomAnnotat]) {
        custAnnots = custAnnots.filter { $0.category != category }
        augTableView.reloadData()
        UIView.animate(withDuration: 2.0) {
            self.myMapView.removeAnnotations(annots)
        }
        // self.myMapView.showAnnotations(self.custAnnots, animated: true)

       // myMapView.removeAnnotations(annots)
    }
    
    func filterAnnotAdd(with category: String, annots: [CustomAnnotat]) {
        custAnnots.append(contentsOf: annots)
        augTableView.reloadData()
        UIView.animate(withDuration: 2.0) {
            self.myMapView.addAnnotations(annots)
        }
        //myMapView.addAnnotations(annots)
    }
    
    func useMilesAndFeet(with distance: Double) -> String {
        var output = ""
       // output = String(format: "%.1f miles", myDouble)
        let miles = (distance * 0.0006214)
        if miles >= 0.2843 {
            output = String(format: "%.1f miles", miles)
        } else {
            let feet = (5280 * miles)
            if feet > 100.0 {
                var newFeet = feet
                newFeet = (newFeet / 100) //* 100
                var tempFeet = Int(newFeet)
                tempFeet = tempFeet * 100
                newFeet = Double(tempFeet)
                output = String(format: "%.0f feet", newFeet)
            } else {
                output = String(format: "%.0f feet", feet)
            }
        }
        return output
    }
    
    
    func readableStrings(with phrase: String) -> String {
        var mutablePhrase = phrase
        let wordsArray = mutablePhrase.components(separatedBy: " ")
        mutablePhrase = ""
        for word in wordsArray {
            if let val = mappingsDict[word] {
                mutablePhrase = mutablePhrase + " " + val
                // now val is not nil and the Optional has been unwrapped, so use it
            } else {
                mutablePhrase = mutablePhrase + " " + word
            }
        }
        return mutablePhrase
    }

    /*
     This is step 0 :Proceed to Delaney Ave
     This is how may meters: 0.0
     This is step 1 :Turn left onto E Gore St
     This is how may meters: 144.0
     This is step 2 :Turn right onto S Orange Ave
     This is how may meters: 163.0
     This is step 3 :Continue onto S Rosalind Ave
     This is how may meters: 271.0
     This is step 4 :Turn right onto E Robinson St
     This is how may meters: 1378.0
     This is step 5 :The destination is on your right
     This is how may meters: 29.0
     */


    
}
