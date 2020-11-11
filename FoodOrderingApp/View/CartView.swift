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
            ScrollView(.vertical, showsIndicators:false){
                LazyVStack(){
                    ForEach(homeVM.cartData){ cartItem in
                        HStack(){
                            WebImage(url: URL(string: cartItem.item.item_image))
                                .resizable()
                                .aspectRatio(contentMode: ContentMode.fill)
                                .frame(width:130, height:130)
                                .cornerRadius(10)
                                .clipped()
                            VStack(spacing:8){
                                Text(cartItem.item.item_name)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                Text(cartItem.item.item_details)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                HStack(){
                                    Text("230")//getPrice
                                        .font(.title2)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                    Spacer(minLength: 0)
                                    
                                    Button(action:{}, label:{
                                        Image(systemName: "minus")
                                            .font(.system(size: 16,weight:.heavy))
                                            .foregroundColor(.black)
                                    })
                                    
                                    Text("\(cartItem.quantity)")
                                        .fontWeight(.bold)
                                        .font(.title)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal,10)
                                        .background(Color.black.opacity(0.06))
                                        
                                    Button(action:{}, label:{
                                        Image(systemName: "plus")
                                            .font(.system(size: 16,weight:.heavy))
                                            .foregroundColor(.black)
                                    })
                                }
                            }
                          
                        }
                        .contentShape(RoundedRectangle(cornerRadius: 15))
                        .contextMenu{
                            Button(action:{
                                let cartIndex = homeVM.cartData.firstIndex { (c) -> Bool in
                                    return c.id == cartItem.id
                                } ?? 0
                                homeVM.cartData.remove(at: cartIndex)
                                
                                let itemIndex = homeVM.items.firstIndex { (c) -> Bool in
                                    return c.id == cartItem.item.id
                                } ?? 0
                                homeVM.items[itemIndex].isAdded = false
                                
                                let filterIndex = homeVM.filtered.firstIndex { (c) -> Bool in
                                    return c.id == cartItem.item.id
                                } ?? 0
                                homeVM.filtered[filterIndex].isAdded = false
                            }, label:{
                                Text("Remove")
                                    .fontWeight(.heavy)
                            })
                        }
                        
                        
                    }
                }
            }.padding()
            
            //Bottom View
            VStack(){
                HStack(){
                    Text("Total")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    Text("2345")
                        .font(.title)
                        .foregroundColor(.black)
                        .fontWeight(.heavy)
                }.padding()
                Button(action:{}, label:{
                    Text("Check Out")
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


