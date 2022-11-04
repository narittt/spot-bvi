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
                if speech.transcript.contains("Hey spot go forward") {
                    Text("Spot going forward")
                } else if speech.transcript.contains("Hey spot go backward") {
                    Text("Spot going backward")
                } else if speech.transcript.contains("Hey spot go left") {
                    Text("Spot going left")
                } else if speech.transcript.contains("Hey spot go right") {
                    Text("Spot going right")
                }
                else {
                    Text("No valid command")
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
