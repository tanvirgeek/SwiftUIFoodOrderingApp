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
                //Top Bar
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
                //Search Bar
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
                
                //food Items from Firebase
                if homeVM.items.isEmpty{
                    Spacer()
                    ProgressView()
                    Spacer()
                }else{
                    ScrollView(){
                        VStack(spacing:25){
                            ForEach(homeVM.filtered){ item in
                                ZStack(alignment:Alignment(horizontal: .center, vertical: .top)){
                                    ItemCard(item: item)
                                    
                                    HStack(){
                                        Text("Free Delivary")
                                            .foregroundColor(.white)
                                            .padding(.vertical,10)
                                            .padding(.horizontal)
                                            .background(Color.pink)
                                        Spacer()
                                        Button(action:{
                                            homeVM.addToCart(item: item)
                                        },label:{
                                            Image(systemName: !item.isAdded ? "plus" : "checkmark")
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(!item.isAdded ? Color.pink : Color.green)
                                                .clipShape(Circle())
                                        })
                                        
                                    }.padding(.trailing,10)
                                    .padding(.top,10)
                                    
                                }.frame(width: UIScreen.main.bounds.width-30)
                                
                            }
                        }
                    }
                }
                
                
                Spacer()
            }
            .onAppear {
                homeVM.locationManager.delegate = homeVM
                
            }.onChange(of: homeVM.search) { (value) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if value == homeVM.search && homeVM.search != ""{
                        homeVM.filterData()
                    }
                    if(homeVM.search == ""){
                        withAnimation(.linear){
                            homeVM.filtered = homeVM.items
                        }
                    }
                }
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
