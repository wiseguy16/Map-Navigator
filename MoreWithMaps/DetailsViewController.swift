//
//  DetailsViewController.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 8/1/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class DetailsViewController: UIViewController {
    
    
    @IBOutlet weak var detailsImage: UIImageView!
    
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var companyTitleLabel: UILabel!
    
    @IBOutlet weak var websiteLabel: UILabel!
    
    
  //  @IBOutlet weak var backDropImageView: UIImageView!
    
    var thedetails: String?
    var anAnnot: CustomAnnotat?
    
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var directionsButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.navigationController?.navigationBar.tintColor = UIColor.white
        setUpDisplay()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let aTitle = anAnnot?.category {
           navigationItem.title = aTitle
        }
        
       // navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpDisplay() {
        callButton.layer.cornerRadius = 4
        callButton.layer.masksToBounds = true
        directionsButton.layer.cornerRadius = 4
        directionsButton.layer.masksToBounds = true
        
        guard let thisAnnot = anAnnot, let urlString = thisAnnot.web, let company = thisAnnot.companyName, let website = thisAnnot.imageName else { return }
        let url = URL(string: urlString)
        detailsImage.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveDownload, .highPriority]) { (image, err , cache, url ) in
            print("loaded")
        }
        
        self.detailsImage.layer.cornerRadius = self.detailsImage.frame.size.height/2
        self.detailsImage.layer.borderWidth = 2.0
        self.detailsImage.layer.borderColor = UIColor.darkGray.cgColor
        self.detailsImage.layer.masksToBounds = true
        
        let appliedStyledWord = applyStyle2(on: company, color: .black, size: 18.0)
        companyTitleLabel.attributedText = appliedStyledWord
        
        if let details = thisAnnot.category {
            print("\(details)")
            
            let placeholderString = "Placeholder text goes here and is easy to see and use and to notice what goes here and that’s something you’ll want to have because it feels really nice and clean and cool."
            //
            let appliedStyledWord = applyStyle1(on: placeholderString, color: .darkGray, size: 10.0)
            detailsLabel.attributedText = appliedStyledWord
        }
        websiteLabel.text = "www." + website
        
        guard let words = thedetails else {
            return
        }
        print("\(words)")
        
        
    }

    
    
    @IBAction func closeTapped(_ sender: UIButton) {
       // zoomINGAnimation()
        //UINavigationController.popToRootViewController(animated: Bool)
        //self.navigationController?.popToRootViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    
    // CALLING A PHONE NUMBER...
    //UIApplication.shared.openURL(NSURL(string: "telprompt://9809088798")! as URL)
    
    @IBAction func callUsingPhoneTapped(_ sender: UIButton) {
        callNumber(phoneNumber: "321-230-4229")
    }
    
 // FUNCTION TO CALL THIS BUSINESS USING PHONE
    private func callNumber(phoneNumber: String) {
        if let phoneCallURL:URL = URL(string:"tel://\(phoneNumber)") {
            let application = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                //application.openURL(phoneCallURL)
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    // FUNCTION TO LAUNCH MAPS APP WITH MKMAPITEM AS DESTINATION
    @IBAction func goToDirectionsTapped(_ sender: UIButton) {
        
        guard let lat = anAnnot?.locatCoordLat, let long = anAnnot?.locatCoordLong, let company = anAnnot?.companyName else {
            return
        }
        let regionDistance: CLLocationDistance = 1000
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coord, regionDistance, regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placeMark = MKPlacemark(coordinate: coord)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = company
        mapItem.openInMaps(launchOptions: options)
        
        
    }
    
    
    func zoomINGAnimation() {
        UIView.animate(withDuration: 2.0, animations: {
            self.detailsImage?.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        }) { (true) in
            UIView.animate(withDuration: 2.0) {
                self.detailsImage?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
        
        
//        UIView.animate(withDuration: 2.0, animations: {() -> Void in
//            self.detailsImage?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//        }, completion: {(_ finished: Bool) -> Void in
//            UIView.animate(withDuration: 2.0, animations: {() -> Void in
//                self.detailsImage?.transform = CGAffineTransform(scaleX: 1, y: 1)
//            })
//        })

    }
    
    func badAnim() {
        UIView.animate(withDuration: 2.0, animations: {
           // self.myMapView.setCamera(camera, animated: true)
        }) { (true) in
            UIView.animate(withDuration: 2.0) {
               // self.createCustomAnnots()
            }
        }

    }



}
