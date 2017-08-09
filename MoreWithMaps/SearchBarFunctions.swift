//
//  SearchBarFunctions.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 8/9/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

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
