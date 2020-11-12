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
    @Published var cartData:[Cart] = []
    @Published var ordered = false
    
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
    
    func addToCart(item:Item){
        
        //
        self.items[getIndex(item: item, isCartIndex: false)].isAdded.toggle()
        self.filtered[getIndex(item: item, isCartIndex: false)].isAdded.toggle()
        
        if item.isAdded{
            self.cartData.remove(at: getIndex(item: item, isCartIndex: true))
            return
        }
        //else adding
        self.cartData.append(Cart(item: item, quantity: 1))
    }
    
    func getIndex(item:Item, isCartIndex:Bool)->Int{
        let index = self.items.firstIndex { (item1) -> Bool in
            return item1.id == item.id
        } ?? 0
        
        let cartIndex = self.cartData.firstIndex { (item1) -> Bool in
            return item.id == item1.item.id
        } ?? 0
        return isCartIndex ? cartIndex : index
    }
    
    func getPrice( at index:Int)-> Double{
        let price = (Double(cartData[index].quantity)) * (cartData[index].item.item_cost as! Double)
        return price
    }
    func getTotalPrice() -> Double {
        var totalPrice:Double = 0
        for (index, _) in cartData.enumerated(){
            totalPrice += self.getPrice(at: index)
        }
        return totalPrice
    }
    
    func updateOrder(){
        let db = Firestore.firestore()
        
        if ordered{
            self.ordered = false
            db.collection("Users").document(Auth.auth().currentUser!.uid).delete {err in
                if err != nil{
                    self.ordered = true
                }
            }
        }else{
            self.ordered = true
            var details:[[String: Any]] = []
            cartData.forEach { (cart) in
                details.append([
                    "item_name": cart.item.item_name,
                    "item_quanitty": cart.quantity,
                    "item_cost": cart.item.item_cost
                ])
            }
            
            db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
                "ordered_food":details,
                "total_cost": getTotalPrice(),
                "location": GeoPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
                
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                    self.ordered = false
                } else {
                    print("Document successfully written!")
                    self.ordered = true
                }
            }
        }
    }
}
