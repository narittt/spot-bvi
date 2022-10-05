//
//  ContentView.swift
//  Spot Leads
//
//  Created by Spot on 7/26/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var speech: SpeechRecognizer


    var body: some View {
        ZStack {
            VStack {
                if speech.transcript.contains("Spot") {
                    Text("ello mate")
                } else {
                    Text("Spot not found")
                }
            }
            VStack {
                //Create Live Transcript subview
                TranscriptView()
                //Create Microphone button subview
                MicView()
                //Creates EStop subview
                EStopView()
            }
        }
        .navigationTitle("Voice Commands")
    }
}

struct ContentView_Previews: PreviewProvider {
    static let speech = SpeechRecognizer()
    static var previews: some View {
        NavigationView {
            ContentView()
        }
        .environmentObject(speech)
    }
}
