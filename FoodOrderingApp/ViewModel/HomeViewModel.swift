//
//  HomeViewModel.swift
//  FoodOrderingApp
//
//  Created by MD Tanvir Alam on 2/11/20.
//

import Foundation
import CoreLocation
import Firebase
import SwiftUI

class HomeViewModel:NSObject, ObservableObject, CLLocationManagerDelegate{
    
    @Published var search = ""
    @Published var locationManager = CLLocationManager()
    @Published var userLocation:CLLocation!
    @Published var userAddress = ""
    @Published var noLocation = false
    @Published var showMenu = false
    @Published var items:[Item] = []
    @Published var filtered:[Item] = []
    
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
        self.login()
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
    
    func login(){
        Auth.auth().signInAnonymously { (res, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("Success = \(res!.user.uid)")
            self.fetchData()
        }
    }
    
    //fetchData
    func fetchData(){
        let db = Firestore.firestore()
        db.collection("items").getDocuments { (snap, error) in
            guard let itemData = snap else {return}
            self.items = itemData.documents.compactMap({ (doc) -> Item? in
                let id = doc.documentID
                let itemCost = doc.get("item_cost") as! NSNumber
                let itemDetailes = doc.get("item_details") as! String
                let itemImage = doc.get("item_image") as! String
                let itemName = doc.get("item_name") as! String
                let itemRating = doc.get("item_rating") as! String
                
                return Item(id: id, item_cost: itemCost, item_details: itemDetailes, item_image: itemImage, item_name: itemName, item_rating: itemRating)
            })
            self.filtered = self.items
        }
        
    }
    func filterData(){
        withAnimation(.linear){
            self.filtered = self.items.filter{
                return $0.item_name.lowercased().contains(self.search.lowercased())
            }
        }
    }
    
}
