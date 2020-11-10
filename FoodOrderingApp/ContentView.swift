//
//  ContentView.swift
//  FoodOrderingApp
//
//  Created by MD Tanvir Alam on 2/11/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView(){
            Home()
        }.navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
