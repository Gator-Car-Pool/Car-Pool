//
//  DetailView.swift
//  Car Pool
//
//  Created by James  Luberisse on 11/24/21.
//

import SwiftUI

struct DetailView : View {
    
        var body: some View {
        
        VStack(alignment: .leading, spacing: 20.0) {
            
            // Meditation Image
            Image("Appicon")
                .resizable()
                .cornerRadius(10)
            
            // Title
            Text("meditation.title")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Description
            Text("meditation.desc")
            
            // GeometryReader for button width
            GeometryReader {
                reader in
                
                // Button stack
                VStack {
                    
                    // Play button
                    Button(action: {
               
                    }, label: {
                                                Text("Stop")
                    })
                    .frame(width: reader.size.width - 40, height: 30, alignment: .center)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
                }
            }
        }
    }
}
