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
        
        ZStack{
            
            VStack(){
                HStack(spacing: 15){
                    Button {
                        withAnimation(.easeIn){
                            homeVM.showMenu.toggle()
                        }
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(.pink)
                    }
                    Text( homeVM.userLocation == nil ? "Locating...":"Deliver to")
                        .foregroundColor(.black)
                    
                    Text(homeVM.userAddress)
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
            }
            .onAppear {
                homeVM.locationManager.delegate = homeVM
                
            }
            
            //Menu
            HStack{
                Menu(homeVM: homeVM)
                    .offset(x: homeVM.showMenu ? 0 : -UIScreen.main.bounds.width/1.6)
                Spacer(minLength: 0)
            }.background(
                Color.black.opacity(homeVM.showMenu ? 0.3 : 0).ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeIn){
                            homeVM.showMenu.toggle()
                        }
                    }
            )
            
            if homeVM.noLocation{
                Text("Please enable location access to settings to furthur move on")
                    .foregroundColor(.black)
            }
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
