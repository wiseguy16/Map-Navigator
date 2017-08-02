//
//  DetailsViewController.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 8/1/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    
    @IBOutlet weak var detailsImage: UIImageView!
    
    @IBOutlet weak var detailsLabel: UILabel!
    var thedetails: String?
    var anAnnot: CustomAnnotat?
    
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var directionsButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        callButton.layer.cornerRadius = 4
        callButton.layer.masksToBounds = true
        directionsButton.layer.cornerRadius = 4
        directionsButton.layer.masksToBounds = true

        
        guard let thisAnnot = anAnnot else { return }
       // detailsImage.image =
        if let urlString = thisAnnot.web {
            let url = URL(string: urlString)
            // let url = changeStringToURL(urlString)
            // print(url)
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        self.detailsImage.image = UIImage(data: data)
                    }


                } catch {
                    
                    print("\(url)")
                    
                }
//                DispatchQueue.main.async {
//                    self.detailsImage.image = UIImage(data: data!)
//                }
            }
            
        }


        guard let words = thedetails else {
            return
        }
        detailsLabel.text = words

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // CALLING A PHONE NUMBER...
    //UIApplication.shared.openURL(NSURL(string: "telprompt://9809088798")! as URL)
    
    @IBAction func callUsingPhoneTapped(_ sender: UIButton) {
        callNumber(phoneNumber: "321-230-4229")
    }
    
    
    private func callNumber(phoneNumber: String) {
        if let phoneCallURL:URL = URL(string:"tel://\(phoneNumber)") {
            let application = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                //application.openURL(phoneCallURL)
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
