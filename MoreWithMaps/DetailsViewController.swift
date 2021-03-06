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
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var theWordHOURS: UILabel!
    @IBOutlet weak var learnMoreLabel: UILabel!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var callLabel: UILabel!
    
    var thedetails: String?
    var anAnnot: CustomAnnotat?
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var directionsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let aTitle = anAnnot?.category {
           navigationItem.title = aTitle
        }
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
        
        let appliedStyledWord = applyStyle2(on: company, color: .black, fontSize: 18.0, kernSize: 0.3)
        companyTitleLabel.attributedText = appliedStyledWord
        
        if let details = thisAnnot.category {
            print("\(details)")
            
            let placeholderString = "Placeholder text goes here and is easy to see and use and to notice what goes here and that’s something you’ll want to have because it feels really nice and clean and cool."
            //
            let appliedStyledWord = applyStyle1(on: placeholderString, color: .darkGray, fontSize: 10.0, kernSize: 0.3)
            detailsLabel.attributedText = appliedStyledWord
        }
        let webString = "www." + website
        let appliedWeb = applyStyle3(on: webString, color: .darkGray, fontSize: 12, kernSize: 0.3)
        websiteLabel.attributedText = appliedWeb
        
        let hoursText = "Monday-Thursday 11 am-3pm\nSaturday 12 pm-5 pm\nSunday 12 pm-3 pm"
        let appliedStyledHours = applyStyle1(on: hoursText, color: .darkGray, fontSize: 10.0, kernSize: 0.3)
        hoursLabel.attributedText = appliedStyledHours
        
        let styledWordHOURS = applyStyle2(on: "Hours", color: .red, fontSize: 12.0, kernSize: 0.8)
        theWordHOURS.attributedText = styledWordHOURS
        let styledDirect = applyStyle4(on: "Directions", color: pantDarkBlue, fontSize: 12.0, kernSize: 0.6)
        directionsLabel.attributedText = styledDirect
        let styledCall = applyStyle4(on: "Call", color: pantDarkBlue, fontSize: 12.0, kernSize: 0.8)
        callLabel.attributedText = styledCall
        let styledLearn = applyStyle4(on: "Learn more", color: pantDarkBlue, fontSize: 12.0, kernSize: 0.8)
        learnMoreLabel.attributedText = styledLearn
    }

    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // CALLING A PHONE NUMBER...
    
    @IBAction func callUsingPhoneTapped(_ sender: UIButton) {
        callNumber(phoneNumber: "321-230-4229")
    }
    
 // FUNCTION TO CALL THIS BUSINESS USING PHONE
    private func callNumber(phoneNumber: String) {
        if let phoneCallURL:URL = URL(string:"tel://\(phoneNumber)") {
            let application = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
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
    }

}
