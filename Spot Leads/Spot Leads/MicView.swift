//
//  MicView.swift
//  Spot Leads
//
//  Created by Spot on 8/5/22.
//

import SwiftUI

struct MicView: View {
    @EnvironmentObject var speech: SpeechRecognizer
    
    var body: some View {
        //Creates circle button
        VStack {
            Circle()
                .strokeBorder(Color.yellow, lineWidth: 12)
                .padding()
                .overlay {
                    Button(action: {
                        speech.reset()
                        speech.transcribe()
                    }) {
                        VStack {
                            Text("Tap to Command")
                                .font(.title)
                                .fontWeight(.light)
                            Image(systemName: "mic")
                                .font(.title)
                                .padding(.top)
                        }
                        .foregroundColor(Color.primary)
                    }
            }
        }
    }
}

struct MicView_Previews: PreviewProvider {
    static let speech = SpeechRecognizer()

    static var previews: some View {
        NavigationView {
            MicView()
                .previewLayout(.sizeThatFits)
        }
        .environmentObject(speech)
    }
}
