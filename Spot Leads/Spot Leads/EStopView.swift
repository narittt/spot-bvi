//
//  EStopView.swift
//  Spot Leads
//
//  Created by Spot on 8/8/22.
//

import SwiftUI

struct EStopView: View {
    @EnvironmentObject var speech: SpeechRecognizer
    
    var body: some View {
        VStack {
            Button(action: {
                speech.stopTranscribing()
                print(speech.transcript)
            }) {
                Image(systemName: "exclamationmark.octagon")
                    .font(.title)
                Text("Emergency Stop")
                    .font(.title).fontWeight(.bold)
                    .padding()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(Color.white)
            .cornerRadius(24)
        }
    }
}

struct EStopView_Previews: PreviewProvider {
    static let speech = SpeechRecognizer()
    static var previews: some View {
        EStopView()
            .environmentObject(speech)
    }
}
