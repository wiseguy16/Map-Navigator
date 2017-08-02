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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
