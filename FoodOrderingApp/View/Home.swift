//
//  Home.swift
//  FoodOrderingApp
//
//  Created by MD Tanvir Alam on 2/11/20.
//

import SwiftUI

struct Home: View {
    @StateObject var homeVM =  HomeViewModel()
    var body: some View {
        VStack(){
            HStack(spacing: 15){
                Button {
                    print("Button Clicked")
                } label: {
                    Image(systemName: "line.horizontal.3")
                        .font(.title)
                        .foregroundColor(.pink)
                }
                Text("Deliver to")
                    .foregroundColor(.black)
                
                Text("Apple")
                    .font(.caption)
                    .fontWeight(.heavy)
                
                Spacer()
            }
            .padding([.horizontal,.top])
            
            Divider()
            
            HStack(){
                TextField("Search", text:$homeVM.search)
                if(homeVM.search != ""){
                    Button(action:{}, label:{
                        
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                            .foregroundColor(.gray)
                        
                    }).animation(.easeIn)
                }
            }
            .padding(.horizontal)
            .padding(.top,10)
            
            Divider()
            Spacer()
        }.onAppear {
            homeVM.locationManager.delegate = homeVM
            homeVM.locationManager.requestWhenInUseAuthorization()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
