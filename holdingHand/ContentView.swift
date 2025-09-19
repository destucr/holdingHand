//
//  ContentView.swift
//  holdingHand
//
//  Created by Auto-generated template.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "hand.wave.fill")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Holding Hand")
                .font(.title)
                .padding()
            Text("Share your lovely moments hold through your hands.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}