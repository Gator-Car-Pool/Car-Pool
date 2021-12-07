//
//  UserProfileViewV2.swift
//  Car Pool
//
//  Created by Brandon Tran on 12/5/21.
//

import SwiftUI

struct UserProfileViewV2: View {
    var body: some View {
        
        HomeV2()
    }
}

struct UserProfileViewV2_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileViewV2()
            .preferredColorScheme(.dark)
    }
}

struct HomeV2 : View {
    
    @State var index = 0
    
    var body: some View{
        
        VStack{
            
            HStack(spacing: 15){
                
//                Button(action: {
//
//                }) {
//
//                    Image(systemName: "chevron.left")
//                        .font(.system(size: 22))
//                        .foregroundColor(.black)
//                }
                
                Text("Profile")
                    .font(.title)
                    .foregroundColor(.primary)
                
                Spacer(minLength: 0)
                
//                Button(action: {
//
//                }) {
//
//                    Text("Add")
//                        .foregroundColor(.white)
//                        .padding(.vertical, 10)
//                        .padding(.horizontal, 25)
//                        .background(Color("Color"))
//                        .cornerRadius(10)
//                }
            }
            .padding()
            
            HStack{
                
                VStack(spacing: 0){
                    
                    Rectangle()
                    .fill(Color("Color"))
                    .frame(width: 80, height: 3)
                    .zIndex(1)
                    
                    
                    // going to apply shadows to look like neuromorphic feel...
                    
                    Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.top, 6)
                    .padding(.bottom, 4)
                    .padding(.horizontal, 8)
//                    .background(Color("Color1"))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                    .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                }
                
                VStack(alignment: .leading, spacing: 12){
                    
                    Text("Kanye West")
                        .font(.title)
//                        .foregroundColor(Color.black.opacity(0.8))
                        .foregroundColor(.primary)
                    
                    Text("kanyewest@ufl.edu")
//                        .foregroundColor(Color.black.opacity(0.7))
                        .foregroundColor(.primary)
                }
                .padding(.leading, 20)
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Tab Items...
            
            HStack{
                
                Button(action: {
                    
                    self.index = 0
                    
                }) {
                    
                    Text("Bio")
//                        .foregroundColor(self.index == 0 ? Color.white : .gray)
//                        .foregroundColor(.secondary)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
//                        .background(self.index == 0 ? Color("Color") : Color.clear)
                        .cornerRadius(10)
                }
                
      
            }
            .padding(.horizontal,8)
            .padding(.vertical,5)
//            .background(Color("Color1"))
            .background(.orange)
            .cornerRadius(8)
//            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
//            .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
            .padding(.horizontal)
            .padding(.top,25)
            
            // Cards...
            
            HStack(spacing: 20){
                
                VStack(spacing: 12){
                    
                    Image(systemName: "message")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.primary)
                    
        
                    
                    Text("Messages")
//                        .foregroundColor(Color("Color"))
                        .foregroundColor(.primary)

                }
                .padding(.vertical)
                // half screen - spacing - two side paddings = 60
                .frame(width: (UIScreen.main.bounds.width - 60) / 2)
//                .background(Color("Color1"))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                // shadows...
                
                VStack(spacing: 12){
                    
                    Image(systemName: "car")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.primary)
                    
             
                    Text("Driver Mode/Rider Mode")
//                        .foregroundColor(Color("Color"))
                        .foregroundColor(.primary)

                }
                .padding(.vertical)
                // half screen - spacing - two side paddings = 60
                .frame(width: (UIScreen.main.bounds.width - 60) / 2)
//                .background(Color("Color1"))
                .foregroundColor(.primary)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                // shadows...
                
            }
            .padding(.top,20)
            
            HStack(spacing: 20){
        
           
                
               
          
            }
            Spacer(minLength: 0)
        }
//        .background(Color("Color1").edgesIgnoringSafeArea(.all))
    }
}
