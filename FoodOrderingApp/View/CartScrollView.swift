//
//  CartScrollView.swift
//  FoodOrderingApp
//
//  Created by MD Tanvir Alam on 11/11/20.
//

import SwiftUI
import SDWebImageSwiftUI
struct CartScrollView: View {
    @ObservedObject var homeVM:HomeViewModel
    var body: some View {
        ScrollView(.vertical, showsIndicators:false){
            LazyVStack(){
                ForEach(homeVM.cartData){ cartItem in
                    let cartIndex = homeVM.cartData.firstIndex { (c) -> Bool in
                        return c.id == cartItem.id
                    } ?? 0
                    let itemIndex = homeVM.items.firstIndex { (c) -> Bool in
                        return c.id == cartItem.item.id
                    } ?? 0
                    let filterIndex = homeVM.filtered.firstIndex { (c) -> Bool in
                        return c.id == cartItem.item.id
                    } ?? 0
                    
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
                                Text(String(format: "%0.1f", homeVM.getPrice(at: cartIndex)))//getPrice
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.black)
                                Spacer(minLength: 0)
                                
                                Button(action:{
                                    if(cartItem.quantity > 1){
                                        homeVM.cartData[cartIndex].quantity -= 1
                                    }
                                    
                                }, label:{
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
                                    
                                Button(action:{
                                    homeVM.cartData[cartIndex].quantity += 1
                                }, label:{
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
                            homeVM.cartData.remove(at: cartIndex)
                            homeVM.filtered[filterIndex].isAdded = false
                            homeVM.items[itemIndex].isAdded = false
                        }, label:{
                            Text("Remove")
                                .fontWeight(.heavy)
                        })
                    }
                    
                    
                }
            }
        }.padding()
    }
}


