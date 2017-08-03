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

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var myMapView: MKMapView!
    let locationManager = CLLocationManager()
    var currentCoord: CLLocationCoordinate2D?
    var steps = [MKRouteStep]()
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
    
    // Var for giving directions
    @IBOutlet weak var directionsGoButton: UIButton!
    
    var destination = MKMapItem()
    
    @IBOutlet weak var augTableView: UITableView!
    
    @IBOutlet weak var augSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var moveTableViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
// artwork courtesy of:  h ttps://mapicons.mapsmarker.com/category/markers/tourism/place-to-see/?custom_color=b4b83f&style=
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // LOCATION MANAGER SETUP
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.stopUpdatingLocation()
        
        self.myMapView.delegate = self
        myMapView.showsUserLocation = true
        myMapView.isRotateEnabled = true
        directionsGoButton.layer.cornerRadius = 10
        directionsGoButton.layer.masksToBounds = true
        hideTable()
        //myMapView.zoomToUserLocation()
        
        // LOAD THE ANNOTATIONS!!!!!!
        zoomToAugusta()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
       // destVC.navigationController?.navigationBar.tintColor = UIColor.white
       // navigationController?.pushViewController(destVC, animated: true)
       // destVC.navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    
    
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
    
    
    @IBAction func filterTapped(_ sender: UIButton) {
        
        let checker = sender.tag
        displaySelectedPoints(with: checker)
    }
    
    func filterAnnotRemove(with category: String, annots: [CustomAnnotat]) {
        custAnnots = custAnnots.filter { $0.category != category }
        augTableView.reloadData()
        myMapView.removeAnnotations(annots)
    }
    
    func filterAnnotAdd(with category: String, annots: [CustomAnnotat]) {
        custAnnots.append(contentsOf: annots)
        augTableView.reloadData()
        myMapView.addAnnotations(annots)
    }
    
    func setupInitialPoints() {
        for i in 1...4 {
            displaySelectedPoints(with: i)
        }
    }
    
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

    
    @IBAction func goToUserLocationTapped(_ sender: UIBarButtonItem) {
        myMapView.zoomToUserLocation(with: myMapView)
    }
    
    
    @IBAction func zoomTapped(_ sender: UIButton) {
       // myMapView.zoomToUserLocation()
    }
    
    @IBAction func giveDirectionsTapped(_ sender: UIButton) {
        let request = MKDirectionsRequest()
       // request.setSource(MKMapItem.forCurrentLocation())
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
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
    
// STEP by STEP DIRECTIONS WITH GEOFENCES TO TELL WHEN TO MOVE
    func getDirections(to destination: MKMapItem) {
        guard let curntCoord = currentCoord else { return }
        let sourcePlacemark = MKPlacemark(coordinate: curntCoord)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = destination
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { (response, error) in
            if error != nil {
                print("You didn't have any results and the error is: \(error!.localizedDescription)")
            }
            guard let response = response else { return }
            guard let primaryRoute = response.routes.first else { return }
            
            self.myMapView.add(primaryRoute.polyline)
            
            self.locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
            
            self.steps = primaryRoute.steps
            for i in 0..<primaryRoute.steps.count {
                let step = primaryRoute.steps[i]
                print(step.instructions)
                print(step.distance)
                let region = CLCircularRegion(center: step.polyline.coordinate, radius: 20, identifier: "\(i)")
                self.locationManager.startMonitoring(for: region)
                let circle = MKCircle(center: region.center, radius: region.radius)
                self.myMapView.add(circle)
            }
        }
    }
    

    
    func createCustomAnnots() {
        for annotDict in annotArry {
            let annot = CustomAnnotat(dictionary: annotDict)
            
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
        setupInitialPoints()
    }
    
    
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
        destination = MKMapItem(placemark: placeMark)
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
            renderer.lineWidth = 10
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
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
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

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let currentLocation = locations.first else { return }
        currentCoord = currentLocation.coordinate
        myMapView.userTrackingMode = .followWithHeading
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        guard let curntCord = currentCoord else { return }
        let region = MKCoordinateRegion(center: curntCord, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        localSearchRequest.region = region
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (response, error) in
            if error != nil {
                print("You didn't have any results and the error is: \(error!.localizedDescription)")
            }
            guard let response = response else { return }
            print(response.mapItems)
            guard let firstItem = response.mapItems.first else { return }
            self.getDirections(to: firstItem)
        }
    }
}


    let annotArry: [[String: AnyObject]] = [
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

