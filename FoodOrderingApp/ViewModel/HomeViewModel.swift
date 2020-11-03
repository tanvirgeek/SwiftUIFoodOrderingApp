//
//  HomeViewModel.swift
//  FoodOrderingApp
//
//  Created by MD Tanvir Alam on 2/11/20.
//

import Foundation
import CoreLocation

class HomeViewModel:NSObject, ObservableObject, CLLocationManagerDelegate{
    
    @Published var search = ""
    @Published var locationManager = CLLocationManager()
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("Authorized")
        case .denied:
            print("Denied")
        default:
            print("Unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
