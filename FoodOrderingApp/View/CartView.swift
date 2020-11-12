//
//  CartView.swift
//  FoodOrderingApp
//
//  Created by MD Tanvir Alam on 10/11/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    @ObservedObject var homeVM:HomeViewModel
    @Environment (\.presentationMode) var present
    var body: some View {
        VStack{
            
            //cart title
            HStack(spacing:20){
                Button(action:{
                    present.wrappedValue.dismiss()
                }, label:{
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy, design: .default))
                        .foregroundColor(Color.pink)
                })
                
                Text("My Cart")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Spacer()
            }.padding()
            
            //Show cart Item in a scroll view
            CartScrollView(homeVM:homeVM)
            
            //Bottom View
            VStack(){
                HStack(){
                    Text("Total")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    Text(String(format: "%.1f", homeVM.getTotalPrice()))
                        .font(.title)
                        .foregroundColor(.black)
                        .fontWeight(.heavy)
                }.padding()
                Button(action:{
                    //Push orderdata to firebase
                    homeVM.updateOrder()
                    
                }, label:{
                    Text( homeVM.ordered ? "Delete Order" : "Give Order")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color.pink)
                        .cornerRadius(15)
                })
            }
            
            Spacer()
        }.navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}


