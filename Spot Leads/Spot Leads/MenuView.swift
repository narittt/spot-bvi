//
//  MenuView.swift
//  Spot Leads
//
//  Created by Spot on 7/26/22.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var speech: SpeechRecognizer
    
    var body: some View {
        List {
            HStack {
                NavigationLink(destination: ContentView()) {
                    Image(systemName: "mic")
                    Text("Voice Control")
                        .font(.headline)
                }
            }
            .padding()
            VStack {
                NavigationLink(destination: NetworkView()) {
                    Image(systemName: "wifi")
                    Text("Network Settings")
                        .font(.headline)
                }
            }
            .padding()
        }
        .padding(.top)
        .navigationTitle("Spot Leads")
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MenuView()
        }
    }
}
