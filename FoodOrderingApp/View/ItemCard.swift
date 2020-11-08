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
        VStack{
            WebImage(url: URL(string: item.item_image))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height:250)
            HStack{
                Text(item.item_name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
        }
    }
}
