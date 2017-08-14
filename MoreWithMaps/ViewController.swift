//
//  ViewController.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 7/28/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation
import FirebaseDatabase


class ViewController: UIViewController {
    
    //Firebase stuff...
    var ref: DatabaseReference?
    var handle: DatabaseHandle?
    var myList: [String] = []
    var cityArray: [[String: AnyObject]] = []
    
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var myTextField: UITextField!
    
    
    let locationManager = CLLocationManager()
    var currentCoord: CLLocationCoordinate2D?
    var steps = [MKRouteStep]()
    var stepCounter = 0
    var custAnnots: [CustomAnnotat] = []
    var businessAnnots: [CustomAnnotat] = []
    var utilityAnnots: [CustomAnnotat] = []
    var foodAnnots: [CustomAnnotat] = []
    var historicAnnots: [CustomAnnotat] = []
    var mkAnnots: [CustomPointAnnotation] = []
    var isTableHidden = false
    var showingFood = false
    var showingHistoric = false
    var showingBusiness = false
    var showingUtility = false
    let upArrow = UIImage(named: "dropUpIcon")
    let downArrow = UIImage(named: "dropDownIcon")
    
    // Karen
    let karen = "com.apple.ttsbundle.Karen-compact"
    // en-AU
    // Daniel
     let daniel = "com.apple.ttsbundle.Daniel-compact"
    // en-GB
    // Moira
     let moira = "com.apple.ttsbundle.Moira-compact"
    // en-IE
    // Samantha
     let samantha = "com.apple.ttsbundle.Samantha-compact"
    // en-US
    // Tessa
     let tessa = "com.apple.ttsbundle.Tessa-compact"
    // en-ZA
     
    
    
    let speechSynthesizer = AVSpeechSynthesizer()
    var uniqueVoice = AVSpeechSynthesisVoice()
    
    // Var for giving directions
    @IBOutlet weak var directionsGoButton: UIButton!
    
    var destinationMapItem = MKMapItem()
    
    
    @IBOutlet weak var directionsLabel: UILabel!
    
    @IBOutlet weak var augTableView: UITableView!
    
    @IBOutlet weak var augSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var moveTableViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
// artwork courtesy of:  h ttps://mapicons.mapsmarker.com/category/markers/tourism/place-to-see/?custom_color=b4b83f&style=
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        ref?.child("Orlando").observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                self.createACustomAnnot(from: dict)
                print("inside if statement\(dict["title"])")
                
                //, finished: {
                    //self.setupInitialPoints()
               // })
            }
            print("Outside of if statement annotCount: \(self.custAnnots.count)")
        })
        
        

        
        
//        handle = ref?.child("Orlando").observe(.value, with: { (snapshot) in
//            if let items = snapshot.value as? [[String: AnyObject]] {
//                for item in items {
//                     print(item)
//                }
//               
//               // print("You have object")
//            }
//        })
        



// LOCATION MANAGER SETUP...
        locationManager.delegate = self
        //locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        
        self.myMapView.delegate = self
        myMapView.showsUserLocation = true
        myMapView.isRotateEnabled = true
        directionsGoButton.layer.cornerRadius = 10
        directionsGoButton.layer.masksToBounds = true
        
        speechSynthesizer.delegate = self
        uniqueVoice = AVSpeechSynthesisVoice(identifier: daniel)!
        
// HIDE THE TABLEVIEW INITIALLY
        hideTable()
        
        //myMapView.zoomToUserLocation()
        
// LOAD THE ANNOTATIONS!!!!!!
       // zoomToAugusta()
       // zoomToMaitland()
        zoomToOrlando()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Before setup annotCount: \(self.custAnnots.count)")

        setupInitialPoints()
        print("After setup annotCount: \(self.custAnnots.count)")

    }
    
    @IBAction func uploadTapped(_ sender: UIButton) {
        if myTextField.text != "" {
            for dict in annotArry {
                //ref?.child("Orlando").child(dict["title"]).
//                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("title").setValue(dict["title"])
//                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("imageName").setValue(dict["imageName"])
//                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("beaconName").setValue(dict["beaconName"])
//                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("locatCoordLat").setValue(dict["locatCoordLat"])
//                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("locatCoordLong").setValue(dict["locatCoordLong"])
//                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("category").setValue(dict["category"])
//                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("web").setValue(dict["web"])
//
                
                ref?.child("Orlando").childByAutoId().updateChildValues(dict, withCompletionBlock: { (error, snapshot) in
                    print("Added dictionaries")
                })
   
                
//                ref?.child("Orlando").childByAutoId().child(dict["title"] as! String).child("title").setValue(dict["title"])
//                ref?.child("Orlando").childByAutoId().child("imageName").setValue(dict["imageName"])
//                ref?.child("Orlando").childByAutoId().child("beaconName").setValue(dict["beaconName"])
//                ref?.child("Orlando").childByAutoId().child("locatCoordLat").setValue(dict["locatCoordLat"])
//                ref?.child("Orlando").childByAutoId().child("locatCoordLong").setValue(dict["locatCoordLong"])
//                ref?.child("Orlando").childByAutoId().child("category").setValue(dict["category"])
//                ref?.child("Orlando").childByAutoId().child("web").setValue(dict["web"])



            }
            //ref?.child("GeoPoint").child(myTextField.text!).setValue(myTextField.text)
           // ref?.child("list").childByAutoId().setValue(myTextField.text)
            myTextField.text = ""
        }
    }
/*
    "title": "Craft & Vine" as AnyObject,
    "imageName": "craftVine.jpg" as AnyObject,
    "beaconName": "sandwich-2.png" as AnyObject,
    "locatCoordLat": 28.626671 as AnyObject,
    "locatCoordLong":  -81.435410 as AnyObject,
    "category": "Food" as AnyObject,
    "web": "http://2kdda41a533r27gnow20hp6whvn.wpengi
*/
    
//MODAL PRESENTATION FOR THE SPONSORED COMPANY...
    @IBAction func moreTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? AugustaCell else {
            return // or fatalError() or whatever
        }
        
        guard let indexPath = augTableView.indexPath(for: cell) else { return }
        let beacon = custAnnots[indexPath.row]
        let destVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        destVC.thedetails = beacon.title
        destVC.anAnnot = beacon
        present(destVC, animated: true, completion: nil)
    }
    
//BRINGS UP THE TABLEVIEW...
    @IBAction func showTapped(_ sender: UIButton) {
        if isTableHidden {
            var adjuster = custAnnots.count
            if adjuster > 3 {
                adjuster = 3
            } else if adjuster > 0 {
                adjuster = custAnnots.count
            } else {
                adjuster = 1
            }
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                self.tableViewHeight.constant = CGFloat(73 * adjuster) //180.0
                sender.setImage(self.upArrow!, for: .normal)
                //sender.setTitle("Hide", for: .normal)
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                self.tableViewHeight.constant = 0.0
                sender.setImage(self.downArrow!, for: .normal)
               // sender.setTitle("Show", for: .normal)
                self.view.layoutIfNeeded()
            }
        }
        isTableHidden = !isTableHidden
    }
    
    
    
    @IBAction func filterTapped(_ sender: UIButton) {
        
        let checker = sender.tag
        displaySelectedPoints(with: checker)
    }
    
    
    
    func setupInitialPoints() {
        for i in 1...4 {
            displaySelectedPoints(with: i)
        }
    }
    
//THIS DETERMINES WHICH CATEGORIES TO SHOW...
    func displaySelectedPoints(with checker: Int) {
        switch checker {
        case 1:
            if showingHistoric {
                filterAnnotRemove(with: "Historic", annots: historicAnnots)
            } else {
                filterAnnotAdd(with: "Historic", annots: historicAnnots)
            }
            showingHistoric = !showingHistoric
        case 2:
            if showingBusiness {
                filterAnnotRemove(with: "Business", annots: businessAnnots)
            } else {
                filterAnnotAdd(with: "Business", annots: businessAnnots)
            }
            showingBusiness = !showingBusiness
        case 3:
            if showingFood {
                filterAnnotRemove(with: "Food", annots: foodAnnots)
            } else {
                filterAnnotAdd(with: "Food", annots: foodAnnots)
            }
            showingFood = !showingFood
        case 4:
            if showingUtility {
                filterAnnotRemove(with: "Utility", annots: utilityAnnots)
            } else {
                filterAnnotAdd(with: "Utility", annots: utilityAnnots)
            }
            showingUtility = !showingUtility
        default:
            print("not a valid button")
        }

    }

//ACTION FOR FIND MY GPS BUTTON...
    @IBAction func goToUserLocationTapped(_ sender: UIBarButtonItem) {
        myMapView.zoomToUserLocation(with: myMapView)
    }
    
    
    @IBAction func zoomTapped(_ sender: UIButton) {
       // myMapView.zoomToUserLocation()
    }

//FIRST SUCCESFUL DIRECTIONS FUNCTION WITH OVERLAY ON MAP AND STEPS LOGGED TO CONSOLE...
    func firstDayDirections() {
        let request = MKDirectionsRequest()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destinationMapItem
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        directions.calculate { (response: MKDirectionsResponse!, error: Error!) in
            if error != nil {
                print("got an errror: \(error.localizedDescription)")
            } else {
                // NO ERROR, SO HERE ARE YOUR DIRECTIONS:.....
                
                // MAYBE DONT REMOVE OVERLAYS HERE?? SOMEHOW RETAIN THE ONE YOU'RE GOING TO?
                let overlays = self.myMapView.overlays
                self.myMapView.removeOverlays(overlays)
                
                for route in response.routes {
                    self.myMapView.add(route.polyline, level: .aboveRoads)
                    var stepNumber = 0
                    for next in route.steps {
                        print("Step \(stepNumber): \(next.instructions)")
                        stepNumber = stepNumber + 1
                    }
                }
            }
        }

    }
    
    func secondDayDirections() {
        getDirections(to: destinationMapItem)
    }

// ACTUAL BUTTON FOR STARTING TURN BY TURN DIRECTIONS...
    @IBAction func giveDirectionsTapped(_ sender: UIButton) {
        //firstDayDirections()
        //let region = CLCircularRegion(center: step.polyline.coordinate, radius: 50, identifier: "\(i)")
        //self.locationManager.startMonitoring(for: region)
        let linesAndCircles = myMapView.overlays
        for lineOrCircle in linesAndCircles {
            if lineOrCircle is MKCircle {
                myMapView.remove(lineOrCircle)
               // locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
            }
            if lineOrCircle is MKPolyline {
                myMapView.remove(lineOrCircle)
            }
        }

        secondDayDirections()
        
    }
    
// STEP by STEP DIRECTIONS WITH GEOFENCES TO TELL WHEN TO MOVE
    func getDirections(to destination: MKMapItem) {
        guard let curntCoord = currentCoord else { return }
        let sourcePlacemark = MKPlacemark(coordinate: curntCoord)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = MKMapItem.forCurrentLocation()
        //directionsRequest.source = sourceMapItem
        directionsRequest.destination = destination
        directionsRequest.transportType = .automobile
        //directionsRequest.transportType = .walking

        directionsRequest.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { (response, error) in
            if error != nil {
                print("You didn't have any results and the error is: \(error!.localizedDescription)")
            }
            guard let response = response else { return }
            guard let primaryRoute = response.routes.first else { return }
            
            self.myMapView.add(primaryRoute.polyline, level: .aboveRoads)
            
            self.locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
            
            self.steps = primaryRoute.steps
            for i in 0..<primaryRoute.steps.count {
                let step = primaryRoute.steps[i]
                print("This is step \(i) :\(step.instructions)")
                print("This is how may meters: \(step.distance)")
                let region = CLCircularRegion(center: step.polyline.coordinate, radius: 40, identifier: "\(i)")
                self.locationManager.startMonitoring(for: region)
                region.notifyOnEntry = true
                
                let circle = MKCircle(center: region.center, radius: region.radius)
                self.myMapView.add(circle)
            }
            
            var speakableMessage = ""
            var printableMessage = ""
            //SPEECH FOR DIRECTIONS!!!...
            let dist1 = self.useMilesAndFeet(with: self.steps[0].distance)
            let dist2 = self.useMilesAndFeet(with: self.steps[1].distance)
            let instr1 = self.readableStrings(with: self.steps[0].instructions)
            let instr2 = self.readableStrings(with: self.steps[1].instructions)
                      if self.steps[0].distance < 0.01 {
                 printableMessage = "\(self.steps[0].instructions). Then in \(dist2), \(self.steps[1].instructions)."
                speakableMessage = "\(instr1). Then in \(dist2), \(instr2)."

            } else {
                 printableMessage = "In \(dist1), \(self.steps[0].instructions). Then in \(dist2), \(self.steps[1].instructions)."
                speakableMessage = "In \(dist1), \(instr1). Then in \(dist2), \(instr2)."
            }
            
            self.directionsLabel.text = printableMessage

            let speechUtterance = AVSpeechUtterance(string: "Starting route. " + speakableMessage)
            speechUtterance.voice = self.uniqueVoice
           // let talker = AVSpeechSynthesisVoice()
           // let talkers = speechVoices()
            
            self.speechSynthesizer.speak(speechUtterance)
            self.stepCounter += 1
        }
        for mntrRegion in locationManager.monitoredRegions {
            print(mntrRegion.identifier)
            print(mntrRegion.notifyOnEntry)
            print(mntrRegion.notifyOnExit)
            
        }
    }
    
    

// INITIALIZING ANNOTS FROM HARD CODED DICTIONARY...
    func createCustomAnnots() {
        for annotDict in annotArry {
            createACustomAnnot(from: annotDict) //, finished: {
            //    setupInitialPoints()
            //})
        
//            let annot = CustomAnnotat(dictionary: annotDict)
//            
//    // CREATE ONLY ARRAY OF 1 OBJECT HERE. PROBABLY EXTEND -> class CustomPointAnnotation: MKPointAnnotation TO HAVE ALL THE PROPERTIES 
//    // THAT ARE IN CustomAnnotat
//    // DONE!!!
//            guard let latd = annot.locatCoordLat, let longd = annot.locatCoordLong, let name = annot.companyName, let theCat = annot.category else { return }
//            
//            let custCoord = CLLocationCoordinate2DMake(latd, longd)
//            annot.coordinate = custCoord
//            let rnd = drand48()
//            let num = Int(1246 * rnd)
//            annot.subtitle = "\(num) Broad Street"
//            annot.title = name
//            
//            switch theCat {
//            case "Food":
//                foodAnnots.append(annot)
//            case "Business":
//                businessAnnots.append(annot)
//            case "Utility":
//                utilityAnnots.append(annot)
//            case "Historic":
//                historicAnnots.append(annot)
//            default:
//                print("not a valid category")
//            }
        }
    //    setupInitialPoints()
    }
    
//TAKE A DICTIONARY AND CREATE A CUSTOM ANNOT
    //func createACustomAnnot(from dict: [String: AnyObject], finished: () -> Void) {
    func createACustomAnnot(from dict: [String: AnyObject]) {

        let annot = CustomAnnotat(dictionary: dict)
        
        // CREATE ONLY ARRAY OF 1 OBJECT HERE. PROBABLY EXTEND -> class CustomPointAnnotation: MKPointAnnotation TO HAVE ALL THE PROPERTIES
        // THAT ARE IN CustomAnnotat
        // DONE!!!
        guard let latd = annot.locatCoordLat, let longd = annot.locatCoordLong, let name = annot.companyName, let theCat = annot.category else { return }
        
        let custCoord = CLLocationCoordinate2DMake(latd, longd)
        annot.coordinate = custCoord
        let rnd = drand48()
        let num = Int(1246 * rnd)
        annot.subtitle = "\(num) Broad Street"
        annot.title = name
        
        switch theCat {
        case "Food":
            foodAnnots.append(annot)
        case "Business":
            businessAnnots.append(annot)
        case "Utility":
            utilityAnnots.append(annot)
        case "Historic":
            historicAnnots.append(annot)
        default:
            print("not a valid category")
        }
       // finished()
    }
    
    
//FIRST INITIAL CONFIG FOR THE MAP AND ZOOM AND CAMERA APPEARANCE
    func zoomToAugusta() {
        let coordinate = CLLocationCoordinate2DMake(33.473244, -81.967437)
        
        // let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 4100, pitch: 0, heading: 23)
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 3000, pitch: 0, heading: 23)
        
        UIView.animate(withDuration: 2.0, animations: {
            self.myMapView.setCamera(camera, animated: true)
        }) { (true) in
            UIView.animate(withDuration: 2.0) {
                self.createCustomAnnots()
            }
        }
    }
    
    func zoomToMaitland() {
        let coordinate = CLLocationCoordinate2DMake(28.540765, -81.384503)
        
        // let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 4100, pitch: 0, heading: 23)
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 7500, pitch: 0, heading: 0)
        
        UIView.animate(withDuration: 2.0, animations: {
            self.myMapView.setCamera(camera, animated: true)
        }) { (true) in
            UIView.animate(withDuration: 2.0) {
                self.createCustomAnnots()
            }
        }
    }
    
    func zoomToOrlando() {
        let coordinate = CLLocationCoordinate2DMake(28.540765, -81.384503)
        
        // let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 4100, pitch: 0, heading: 23)
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 7500, pitch: 0, heading: 0)
        
        UIView.animate(withDuration: 2.0, animations: {
            self.myMapView.setCamera(camera, animated: true)
        }) { (true) in
            UIView.animate(withDuration: 2.0) {
               // self.createCustomAnnots()
            }
        }
    }

    
}

extension ViewController: AVSpeechSynthesizerDelegate {
    
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
//        
//    }
}


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

//        if region is CLCircularRegion {
//            if region.identifier == "0" {
//                handleEvent(forRegion: "Entered \(region.identifier)")
//            }
//        }
//        if region is CLCircularRegion {
//            if region.identifier == "1" {
//                handleEvent(forRegion: "Entered \(region.identifier)")
//            }
//        }
//        if region is CLCircularRegion {
//            if region.identifier == "2" {
//                handleEvent(forRegion: "Entered \(region.identifier)")
//            }
//        }



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
        routeLine.strokeColor = UIColor.purple
        routeLine.lineWidth = 6.0
        
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5.0
            return renderer
        }
        
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.strokeColor = .red
            renderer.fillColor = .red
            renderer.alpha = 0.5
            return renderer
        } else {
            return routeLine
        }
    }

}


// HARD CODED BEACON/ANNOTS DICTIONARY...
    let annotArry: [[String: AnyObject]] = [
        ["title": "Craft & Vine" as AnyObject,
         "imageName": "craftVine.jpg" as AnyObject,
         "beaconName": "sandwich-2.png" as AnyObject,
         "locatCoordLat": 28.626671 as AnyObject,
         "locatCoordLong":  -81.435410 as AnyObject,
         "category": "Food" as AnyObject,
         "web": "http://2kdda41a533r27gnow20hp6whvn.wpengine.netdna-cdn.com/wp-content/uploads/2014/06/Craft-and-Vine2-660x390.jpg" as AnyObject],
        ["title": "Humanitree House" as AnyObject,
         "imageName": "humaniTree.jpg" as AnyObject,
         "beaconName": "citysquare.png" as AnyObject,
         "locatCoordLat": 28.632066 as AnyObject,
         "locatCoordLong":  -81.431256 as AnyObject,
         "category": "Historic" as AnyObject,
         "web": "http://augustalocallygrown.org/wp-content/uploads/xHumanitree_1-1024x768.jpg.pagespeed.ic.UmRq1dFKDX.jpg" as AnyObject],
        ["title": "Metro Coffee House" as AnyObject,
         "imageName": "metro.jpg" as AnyObject,
         "beaconName": "lighthouse-2.png" as AnyObject,
         "locatCoordLat": 28.635230 as AnyObject,
         "locatCoordLong": -81.436105 as AnyObject,
         "category": "Utility" as AnyObject,
         "web": "http://scontent-atl3-1.xx.fbcdn.net/v/t1.0-9/10891433_10155074380045414_8644919409126086956_n.jpg?oh=aa8dc9887385fb7594335f6741af935a&oe=5A026827" as AnyObject],
        ["title": "MOD Ink" as AnyObject,
         "imageName": "modInk.jpg" as AnyObject,
         "beaconName": "treasure_chest.png" as AnyObject,
         "locatCoordLat": 28.638891 as AnyObject,
         "locatCoordLong":  -81.440309 as AnyObject,
         "category": "Business" as AnyObject,
         "web": "http://static1.squarespace.com/static/58a8d93ecd0f68a08214dd2a/58a90f99e58c62fa406bfd1c/58aa7228579fb32b000236fa/1487902510435/MODFRONT.jpg?format=1500w" as AnyObject],
        ["title": "The New Moon Cafe" as AnyObject,
         "imageName": "newMoon.jpg" as AnyObject,
         "beaconName": "sandwich-2.png" as AnyObject,
         "locatCoordLat": 28.5704 as AnyObject,
         "locatCoordLong": -81.3440 as AnyObject,
         "category": "Food" as AnyObject,
         "web": "http://newmoondowntown.homestead.com/files/QuickSiteImages/Menus_01.gif" as AnyObject],
        ["title": "Mellow Mushroom Pizza" as AnyObject,
         "imageName": "mellowMushroom.jpg" as AnyObject,
         "beaconName": "citysquare.png" as AnyObject,
         "locatCoordLat": 28.5563 as AnyObject,
         "locatCoordLong": -81.3545 as AnyObject,
         "category": "Historic" as AnyObject,
         "web": "http://2kdda41a533r27gnow20hp6whvn.wpengine.netdna-cdn.com/wp-content/uploads/2014/06/Mellow_Mushroom1-1-DT.jpg" as AnyObject],
        ["title": "The Pizza Joint" as AnyObject,
         "imageName": "pizzaJoint.jpg" as AnyObject,
         "beaconName": "lighthouse-2.png" as AnyObject,
         "locatCoordLat": 28.5412 as AnyObject,
         "locatCoordLong": -81.3853 as AnyObject,
         "category": "Utility" as AnyObject,
         "web": "http://www.myherocard.com/wp-content/uploads/2016/07/Slider-1-913x240.jpg" as AnyObject],
        ["title": "Stillwater Tap Room" as AnyObject,
         "imageName": "stillWater.jpg" as AnyObject,
         "beaconName": "treasure_chest.png" as AnyObject,
         "locatCoordLat": 28.5455 as AnyObject,
         "locatCoordLong": -81.3756 as AnyObject,
         "category": "Business" as AnyObject,
         "web": "http://2kdda41a533r27gnow20hp6whvn.wpengine.netdna-cdn.com/wp-content/uploads/2016/03/stillwater-1.jpg" as AnyObject]
]

let annotArry2: [[String: AnyObject]] = [
    ["title": "Craft & Vine" as AnyObject,
     "imageName": "craftVine.jpg" as AnyObject,
     "beaconName": "sandwich-2.png" as AnyObject,
     "locatCoordLat": 33.474223 as AnyObject,
     "locatCoordLong": -81.966396 as AnyObject,
     "category": "Food" as AnyObject,
     "web": "http://2kdda41a533r27gnow20hp6whvn.wpengine.netdna-cdn.com/wp-content/uploads/2014/06/Craft-and-Vine2-660x390.jpg" as AnyObject],
    ["title": "Humanitree House" as AnyObject,
     "imageName": "humaniTree.jpg" as AnyObject,
     "beaconName": "citysquare.png" as AnyObject,
     "locatCoordLat": 33.475723 as AnyObject,
     "locatCoordLong": -81.967896 as AnyObject,
     "category": "Historic" as AnyObject,
     "web": "http://augustalocallygrown.org/wp-content/uploads/xHumanitree_1-1024x768.jpg.pagespeed.ic.UmRq1dFKDX.jpg" as AnyObject],
    ["title": "Metro Coffee House" as AnyObject,
     "imageName": "metro.jpg" as AnyObject,
     "beaconName": "lighthouse-2.png" as AnyObject,
     "locatCoordLat": 33.476423 as AnyObject,
     "locatCoordLong": -81.969396 as AnyObject,
     "category": "Utility" as AnyObject,
     "web": "http://scontent-atl3-1.xx.fbcdn.net/v/t1.0-9/10891433_10155074380045414_8644919409126086956_n.jpg?oh=aa8dc9887385fb7594335f6741af935a&oe=5A026827" as AnyObject],
    ["title": "MOD Ink" as AnyObject,
     "imageName": "modInk.jpg" as AnyObject,
     "beaconName": "treasure_chest.png" as AnyObject,
     "locatCoordLat": 33.475723 as AnyObject,
     "locatCoordLong": -81.965796 as AnyObject,
     "category": "Business" as AnyObject,
     "web": "http://static1.squarespace.com/static/58a8d93ecd0f68a08214dd2a/58a90f99e58c62fa406bfd1c/58aa7228579fb32b000236fa/1487902510435/MODFRONT.jpg?format=1500w" as AnyObject],
    ["title": "The New Moon Cafe" as AnyObject,
     "imageName": "newMoon.jpg" as AnyObject,
     "beaconName": "sandwich-2.png" as AnyObject,
     "locatCoordLat": 33.474 as AnyObject,
     "locatCoordLong": -81.971 as AnyObject,
     "category": "Food" as AnyObject,
     "web": "http://newmoondowntown.homestead.com/files/QuickSiteImages/Menus_01.gif" as AnyObject],
    ["title": "Mellow Mushroom Pizza" as AnyObject,
     "imageName": "mellowMushroom.jpg" as AnyObject,
     "beaconName": "citysquare.png" as AnyObject,
     "locatCoordLat": 33.477 as AnyObject,
     "locatCoordLong": -81.964 as AnyObject,
     "category": "Historic" as AnyObject,
     "web": "http://2kdda41a533r27gnow20hp6whvn.wpengine.netdna-cdn.com/wp-content/uploads/2014/06/Mellow_Mushroom1-1-DT.jpg" as AnyObject],
    ["title": "The Pizza Joint" as AnyObject,
     "imageName": "pizzaJoint.jpg" as AnyObject,
     "beaconName": "lighthouse-2.png" as AnyObject,
     "locatCoordLat": 33.473 as AnyObject,
     "locatCoordLong": -81.966 as AnyObject,
     "category": "Utility" as AnyObject,
     "web": "http://www.myherocard.com/wp-content/uploads/2016/07/Slider-1-913x240.jpg" as AnyObject],
    ["title": "Stillwater Tap Room" as AnyObject,
     "imageName": "stillWater.jpg" as AnyObject,
     "beaconName": "treasure_chest.png" as AnyObject,
     "locatCoordLat": 33.472 as AnyObject,
     "locatCoordLong": -81.968 as AnyObject,
     "category": "Business" as AnyObject,
     "web": "http://2kdda41a533r27gnow20hp6whvn.wpengine.netdna-cdn.com/wp-content/uploads/2016/03/stillwater-1.jpg" as AnyObject]
]


/*
 @IBAction func zoomToAugustaTapped(_ sender: UIButton) {
 let coordinate = CLLocationCoordinate2DMake(33.473244, -81.967437)
 
 // let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 4100, pitch: 0, heading: 23)
 let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 3000, pitch: 0, heading: 23)
 
 UIView.animate(withDuration: 2.0, animations: {
 self.myMapView.setCamera(camera, animated: true)
 }) { (true) in
 UIView.animate(withDuration: 2.0) {
 self.createCustomAnnots()
 }
 }
 }

 
 
 
 func createCustomAnnotation(with locatCoordLat: CLLocationDegrees, locatCoordLong: CLLocationDegrees,  title: String, imageName: String, beaconName: String) {
 let customAnnot = CustomPointAnnotation()
 let custCoord = CLLocationCoordinate2DMake(locatCoordLat, locatCoordLong)
 customAnnot.coordinate = custCoord
 let rnd = drand48()
 let num = Int(1246 * rnd)
 customAnnot.subtitle = "\(num) Broad Street"
 customAnnot.title = title
 customAnnot.beaconName = beaconName
 customAnnot.imageName = imageName
 mkAnnots.append(customAnnot)
 myMapView.addAnnotation(customAnnot)
 }
 
 
 @IBAction func filterShopsPicked(_ sender: UISegmentedControl) {
 let indx = sender.selectedSegmentIndex
 switch indx {
 case 0:
 print("Restaurants")
 augTableView.reloadData()
 case 1:
 print("Shops")
 //myMapView.removeAnnotations(custAnnots)
 augTableView.reloadData()
 case 2:
 print("Points Of Interest")
 augTableView.reloadData()
 default:
 print("Didn't pick anything")
 }
 }


 */

