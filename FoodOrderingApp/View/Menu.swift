//
//  Menu.swift
//  FoodOrderingApp
//
//  Created by MD Tanvir Alam on 5/11/20.
//

import SwiftUI

struct Menu: View {
    @ObservedObject var homeVM:HomeViewModel
    var body: some View {
        VStack{
            NavigationLink(destination: CartView(homeVM: homeVM), label: {
                HStack{
                    Image(systemName: "cart")
                        .font(.title)
                        .foregroundColor(.pink)
                    Text("Cart")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
            }).padding()
            
            Spacer(minLength: 0)
            
            HStack(){
                Spacer()
                Text("Version 1.0")
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
            }.padding(10)
        }.frame(width: UIScreen.main.bounds.width / 1.6)
        .background(Color.white.ignoresSafeArea())
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu(homeVM: HomeViewModel())
    }
}
