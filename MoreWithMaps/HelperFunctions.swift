//
//  HelperFunctions.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 8/6/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

extension ViewController {
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
    
    // HELPER FUNCTIONS FOR ADDING/ REMOVING COMPANIES
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


    
}
