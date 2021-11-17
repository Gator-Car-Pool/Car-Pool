//
//  ContentView.swift
//  Car Pool
//
//  Created by Valerie Chery on 11/15/21.
//

import SwiftUI

// app splash screen
struct SplashPageView: View {
    @State var animate = false
    @State var endSplash = false
    
    var body: some View {
        ZStack {
            
            Home()
            
            ZStack {
                Color("background")
                
                Image("iconLarge")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: animate ? .fill : .fit)
                    .frame(width: animate ? nil : 85, height: animate ? nil : 85)
                
                // scaling view
                    .scaleEffect(animate ? 3 : 1)
                
                // set width to avoid oversizing
                    .frame(width: UIScreen.main.bounds.width)
            }
            .ignoresSafeArea(.all, edges: .all)
            .onAppear(perform: animateSplash)
            // hide view after finishing animation
            .opacity(endSplash ? 0 : 1)
        }
    }
        
        func animateSplash() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation(Animation.easeOut(duration: 0.45)) {
                    animate.toggle()
                }
                withAnimation(Animation.easeOut(duration: 0.35)) {
                    endSplash.toggle()
                }
            }
        }
    }

struct Home : View {
    var body : some View {
        VStack {
            HStack {
                Text("Gator Carpool")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color("background"))
                
                Spacer(minLength: 0)
            }
            .padding()
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            .background(Color.white)
            
            Spacer()
        }
        
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.black.opacity(0.06).ignoresSafeArea(.all, edges: .all))
    }
}

struct SplashPageView_Previews: PreviewProvider {
    static var previews: some View {
        SplashPageView()
    }
}
