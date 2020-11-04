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
    @Published var userLocation:CLLocation!
    @Published var userAddress = ""
    @Published var noLocation = false
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("Authorized")
            self.noLocation = false
            manager.requestLocation()
        case .denied:
            print("Denied")
            self.noLocation = true
        default:
            print("Unknown")
            self.noLocation = false
           locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations.last
        self.extractLocation()
    }
    func extractLocation(){
        CLGeocoder().reverseGeocodeLocation(self.userLocation){ res , error in
            guard let safedata = res else{return}
            var address = ""
            
            address += safedata.first?.name ?? ""
            address += ", "
            address += safedata.first?.locality ?? ""
            
            self.userAddress = address
            
        }
    }
    
}
