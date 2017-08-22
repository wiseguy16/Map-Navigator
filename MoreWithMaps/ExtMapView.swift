//
//  ExtMapView.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 8/22/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

extension ViewController: MKMapViewDelegate {
    //DEFINING APPEARANCE FOR THE ANNOTATIONS...THESE ARE DELEGATE METHODS
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation) {
            print("NOT REGISTERED AS MKPOINTANNOTATION")
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "customAnnot")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customAnnot")
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        //let cpa = annotation as! CustomPointAnnotation
        let cpa = annotation as! CustomAnnotat
        if let beaconName = cpa.beaconName {
            annotationView!.image = UIImage(named: beaconName)
        }
        
        //Added to git
        // annotationView!.image = UIImage(named: cpa.imageName)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // print("I selected a placemark")
        guard let coord = view.annotation?.coordinate else { return }
        print("placemark is: \(coord.latitude) \(coord.longitude)")
        // create a placemark and a map item
        let placeMark = MKPlacemark(coordinate: coord)
        // This is needed when we need to get directions
        destinationMapItem = MKMapItem(placemark: placeMark)
        
    }
    
    // DRAWING THE DIRECTIONS ON MAP.....
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // PROBABLY BOTH THESE WORK??
        
        let routeLine = MKPolylineRenderer(overlay: overlay)
        routeLine.strokeColor = .blue
        routeLine.lineWidth = 6.0
        
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.purple
            renderer.lineWidth = 5.0
            return renderer
        }
        
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.strokeColor = .red
            renderer.fillColor = .red
            renderer.alpha = 0.3
            return renderer
        } else {
            return routeLine
        }
    }
    
    
}
