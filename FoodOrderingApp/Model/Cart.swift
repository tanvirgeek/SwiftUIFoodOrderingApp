//
//  Cart.swift
//  FoodOrderingApp
//
//  Created by MD Tanvir Alam on 10/11/20.
//

import Foundation

struct Cart:Identifiable {
    var id = UUID().uuidString
    var item:Item
    var quantity:Int
}
