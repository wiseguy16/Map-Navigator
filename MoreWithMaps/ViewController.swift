//
//  ViewController.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 7/28/17.
//  Copyright © 2017 gergusa. All rights reserved.
//
// artwork courtesy of:  https://mapicons.mapsmarker.com/category/markers/tourism/place-to-see/?custom_color=b4b83f&style=

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
    var firArray: [[String: AnyObject]] = []
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
    var hasDisplayedAnnotsOnce = false
    let upArrow = UIImage(named: "Shape-Caret-Up")
    let downArrow = UIImage(named: "Shape-Caret-Down")
    var areCategoriesHidden = true
    
    // @IBOutlet weak var categoriesButton: UIButton!
    @IBOutlet weak var categoryBackground: UIView!

    // Daniel
    let daniel = "com.apple.ttsbundle.Daniel-compact"
    // en-GB

    let speechSynthesizer = AVSpeechSynthesizer()
    // Var for giving directions
    var uniqueVoice = AVSpeechSynthesisVoice()
    
    @IBOutlet weak var directionsGoButton: UIButton!
    var destinationMapItem = MKMapItem()
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var augTableView: UITableView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var moveCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var resultsButton: UIButton!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var stringArray: [String] = []
    var keyArray: [String] = []
    var myDictionary: [String: AnyObject] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDisplay()
        ref = Database.database().reference()
        getInitialData()
        setupLocationManager()
        setupMapViewProperties()
        
        speechSynthesizer.delegate = self
        uniqueVoice = AVSpeechSynthesisVoice(identifier: daniel)!
        
        // HIDE THE TABLEVIEW INITIALLY
        hideTable()
        zoomToOrlando(at: 4.0)
        
        // MARK: For testing different loactions..
        /*
         myMapView.zoomToUserLocation()
         LOAD THE ANNOTATIONS!!!!!!
         zoomToAugusta()
         zoomToMaitland()
         */
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
    }
    
    func setupMapViewProperties() {
        self.myMapView.delegate = self
        myMapView.showsUserLocation = true
        myMapView.isRotateEnabled = true
        myMapView.showsPointsOfInterest = false
        myMapView.showsBuildings = false
    }
    
    func setUpDisplay() {
        categoryBackground.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.85)
        directionsGoButton.layer.cornerRadius = 10
        directionsGoButton.layer.masksToBounds = true
        resultsLabel.layer.cornerRadius = 5
        resultsLabel.layer.masksToBounds = true
        let resultsTap = UITapGestureRecognizer(target: self, action: #selector (bringUpResultsView) )
        resultsLabel.addGestureRecognizer(resultsTap)
    }
    
    func checkForChangedData() {
        
        ref?.child("Orlando").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict1 = snapshot.value as? [String: AnyObject] {
                for snapKey in dict1.keys {
                    if let snapDict = dict1[snapKey] as? [String: AnyObject] {
                        self.createACustomAnnot(from: snapDict)
                    }
                    print(snapKey)
                }
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        self.setupInitialPoints()
                    }
                    DispatchQueue.main.async {
                        self.myCollectionView.reloadData()
                    }
                    DispatchQueue.main.async {
                        self.view.setNeedsDisplay()
                    }
                }
            }
        })
    }
    
    func resetMap() {
        self.myMapView.removeAnnotations(self.custAnnots)
        self.custAnnots.removeAll()
        self.businessAnnots.removeAll()
        self.utilityAnnots.removeAll()
        self.foodAnnots.removeAll()
        self.historicAnnots.removeAll()
        self.showingFood = !self.showingFood
        self.showingHistoric = !self.showingHistoric
        self.showingBusiness = !self.showingBusiness
        self.showingUtility = !self.showingUtility
        self.myCollectionView.reloadData()
        
    }
    
    func getInitialData() {
        ref?.child("Orlando").observe(.value, with: { (snapshot) in
            self.resetMap()
            
            if let dict1 = snapshot.value as? [String: AnyObject] {
                for snapKey in dict1.keys {
                    if let snapDict = dict1[snapKey] as? [String: AnyObject] {
                        self.createACustomAnnot(from: snapDict)
                    }
                    print(snapKey)
                }
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        self.setupInitialPoints()
                    }
                    DispatchQueue.main.async {
                        self.myCollectionView.reloadData()
                    }
                    DispatchQueue.main.async {
                        self.view.setNeedsDisplay()
                    }
                }
            }
        })
        resetMap()
    }
    
    @IBAction func goBackHomeTapped(_ sender: UIButton) {
        zoomToOrlando(at: 2.0)
    }
    
    @IBAction func zoomInTapped(_ sender: UIButton) {
        
        myMapView.setZoomByDelta(delta: 0.5, animated: true)
    }
    
    @IBAction func zoomOutTapped(_ sender: UIButton) {
        myMapView.setZoomByDelta(delta: 2.0, animated: true)
        
    }
    
    @IBAction func uploadTapped(_ sender: UIButton) {
        if myTextField.text != "" {
            for dict in annotArry {
                ref?.child("Orlando").child("\(dict["title"]!)").updateChildValues(dict, withCompletionBlock: { (error, snapshot) in
                    print("Added dictionaries")
                })
            }
            myTextField.text = ""
        }
    }
    
    // NOW USING PREPARE FOR SEGUE INSTEAD OF MODAL
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let button = sender as? UIButton {
            guard let cell = button.superview?.superview as? MyCollectionCell else {
                return // or fatalError() or whatever
            }
            if segue.identifier == "DetailSegue" {
                guard let indexPath = myCollectionView.indexPath(for: cell) else { return }
                let beacon = custAnnots[indexPath.row]
                let destVC = segue.destination as! DetailsViewController
                let backImg: UIImage = UIImage(named: "backArrowWhite")!
                navigationController?.navigationBar.backIndicatorImage = backImg
                navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImg
                let backItem = UIBarButtonItem()
                backItem.title = " "
                navigationItem.backBarButtonItem = backItem
                navigationController?.navigationBar.tintColor = .white
                destVC.thedetails = beacon.title
                destVC.anAnnot = beacon
            }
        }
    }
    
    @IBAction func showCategoriesTapped(_ sender: UIBarButtonItem) {
        bringOutCategoriesMenu()
    }
    
    @IBAction func revealCategoriesTapped(_ sender: UIButton) {
        // Not used anymore!!
    }
    
    func bringOutCategoriesMenu() {
        if areCategoriesHidden {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: {
                self.categoryMenuConstraint.constant = 0.0
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.categoryMenuConstraint.constant = -550.0
                self.view.layoutIfNeeded()
            })
        }
        areCategoriesHidden = !areCategoriesHidden
    }
    
    //BRINGS UP THE TABLEVIEW...
    @IBAction func showTapped(_ sender: UIButton) {
        bringUpResultsView()
    }
    
    func bringUpResultsView() {
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
                self.myCollectionView.reloadData()
                self.collectionViewHeight.constant = CGFloat(100 * adjuster) //180.0
                self.resultsButton.setImage(self.downArrow!, for: .normal)
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                self.myCollectionView.reloadData()
                self.collectionViewHeight.constant = 0.0
                self.resultsButton.setImage(self.upArrow!, for: .normal)
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
    
    // ACTUAL BUTTON FOR STARTING TURN BY TURN DIRECTIONS...
    @IBAction func giveDirectionsTapped(_ sender: UIButton) {
        
        let linesAndCircles = myMapView.overlays
        for lineOrCircle in linesAndCircles {
            if lineOrCircle is MKCircle {
                myMapView.remove(lineOrCircle)
            }
            if lineOrCircle is MKPolyline {
                myMapView.remove(lineOrCircle)
            }
        }
        secondDayDirections()
    }
    
    // INITIALIZING ANNOTS FROM HARD CODED DICTIONARY...
    func createCustomAnnots() {
        for annotDict in annotArry {
            createACustomAnnot(from: annotDict)
        }
    }
    
    //TAKE A DICTIONARY AND CREATE A CUSTOM ANNOT
    
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
    }
    
    //FIRST INITIAL CONFIG FOR THE MAP AND ZOOM AND CAMERA APPEARANCE
    func zoomToAugusta() {
        let coordinate = CLLocationCoordinate2DMake(33.473244, -81.967437)
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
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 7500, pitch: 0, heading: 0)
        
        UIView.animate(withDuration: 2.0, animations: {
            self.myMapView.setCamera(camera, animated: true)
        }) { (true) in
            UIView.animate(withDuration: 2.0) {
                self.createCustomAnnots()
            }
        }
    }
    
    func zoomToOrlando(at speed: TimeInterval) {
        let coordinate = CLLocationCoordinate2DMake(28.540765, -81.384503)
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 7500, pitch: 0, heading: 0)
        UIView.animate(withDuration: speed) {
            self.myMapView.setCamera(camera, animated: true)
        }
    }
    
}

// MARK: Speech and Directions
extension ViewController {
    
    // STEP by STEP DIRECTIONS WITH GEOFENCES TO TELL WHEN TO MOVE
    func getDirections(to destination: MKMapItem) {
        guard let curntCoord = currentCoord else { return }
        let sourcePlacemark = MKPlacemark(coordinate: curntCoord)
        _ = MKMapItem(placemark: sourcePlacemark)
        
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = MKMapItem.forCurrentLocation()
        directionsRequest.destination = destination
        directionsRequest.transportType = .automobile
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
            self.speechSynthesizer.speak(speechUtterance)
            self.stepCounter += 1
        }
        for mntrRegion in locationManager.monitoredRegions {
            print(mntrRegion.identifier)
            print(mntrRegion.notifyOnEntry)
            print(mntrRegion.notifyOnExit)
        }
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
    
}

extension ViewController: AVSpeechSynthesizerDelegate {
    // All optional methods
}
