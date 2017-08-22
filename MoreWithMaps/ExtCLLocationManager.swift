//
//  ExtCLLocationManager.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 8/22/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        myMapView.showsUserLocation = true
        guard let currentLocation = locations.last else { return }
        currentCoord = currentLocation.coordinate
        print("\(currentCoord)")
        //myMapView.userTrackingMode = .followWithHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        showAlert(withTitle: "LocMngr Alert!", message: "You Entered a Region")
        
        print("Entered CLCircular region \(region.identifier)")
        
        if region is CLCircularRegion {
            handleEvent(forRegion: "Entered \(region.identifier)")
            // myMapView.remove(region.identifier as! MKOverlay)
            // locationManager.stopMonitoring(for: region)
        }
        
        stepCounter += 1
        if stepCounter < steps.count {
            let currentStep = steps[stepCounter]
            //let miles = Int(currentStep.distance * 0.0006214)
            let miles = useMilesAndFeet(with: currentStep.distance)
            
            let printableMessage = "In \(miles), \(currentStep.instructions)."
            let readableMessage = readableStrings(with: currentStep.instructions)
            let message = "In \(miles), \(readableMessage)"
            directionsLabel.text = printableMessage
            let speechUtterance = AVSpeechUtterance(string: message)
            speechUtterance.voice = self.uniqueVoice
            speechSynthesizer.speak(speechUtterance)
        } else {
            let message = "Arrived at destination."
            directionsLabel.text = message
            let speechUtterance = AVSpeechUtterance(string: message)
            speechUtterance.voice = self.uniqueVoice
            speechSynthesizer.speak(speechUtterance)
            stepCounter = 0
            locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
        }
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        showAlert(withTitle: "LocMngr Alert!", message: "You Exited a Region")
        
        if region is CLCircularRegion {
            handleEvent(forRegion: "Exited \(region.identifier)")
            //locationManager.stopMonitoring(for: region)
        }
        
    }
    func handleEvent(forRegion regionPhrase: String) {
        let speechUtterance = AVSpeechUtterance(string: "You have \(regionPhrase) the region")
        //speechSynthesizer.speak(speechUtterance)
        
    }
    
}

