//
//  ItemCard.swift
//  FoodOrderingApp
//
//  Created by MD Tanvir Alam on 8/11/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemCard: View {
    var item:Item
    var body: some View {
        VStack(spacing:5){
            WebImage(url: URL(string: item.item_image))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height:250)
                .clipped()
            
            HStack(spacing:8){
                Text(item.item_name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer(minLength: 0)
                ForEach(1...5, id: \.self){ index in
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= Int(item.item_rating) ?? 0 ? Color.pink : Color.gray)
                }
            }
            
            HStack(){
                Text(item.item_details)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                Spacer(minLength: 0)
            }
        }.padding(.bottom,20)
    }
}
