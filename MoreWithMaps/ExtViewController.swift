//
//  ExtViewController.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 8/22/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

let pantDarkGreen = UIColor(colorLiteralRed: 80/255.0, green: 97/255.0, blue: 62/255.0, alpha: 1.0)
let pantLightGreen = UIColor(colorLiteralRed: 121/255.0, green: 160/255.0, blue: 62/255.0, alpha: 1.0)
let pantBeige = UIColor(colorLiteralRed: 199/255.0, green: 160/255.0, blue: 131/255.0, alpha: 1.0)
let pantYellow = UIColor(colorLiteralRed: 243/255.0, green: 195/255.0, blue: 70/255.0, alpha: 1.0)
let pantDarkBlue = UIColor(colorLiteralRed: 0/255.0, green: 68/255.0, blue: 125/255.0, alpha: 1.0)
let pantMidBlue = UIColor(colorLiteralRed: 64/255.0, green: 122/255.0, blue: 152/255.0, alpha: 1.0)
let pantOrange = UIColor(colorLiteralRed: 233/255.0, green: 78/255.0, blue: 33/255.0, alpha: 1.0)
let pantPink = UIColor(colorLiteralRed: 203/255.0, green: 48/255.0, blue: 102/255.0, alpha: 1.0)

extension UIViewController {
    func addBlur(onImage bgView: UIImageView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bgView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgView.addSubview(blurEffectView)
    }

}






