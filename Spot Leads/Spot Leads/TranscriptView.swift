//
//  TranscriptView.swift
//  Spot Leads
//
//  Created by Spot on 8/5/22.
//

import SwiftUI

struct TranscriptView: View {
    @EnvironmentObject var speech: SpeechRecognizer

    var body: some View {
        VStack {
            Text("Live transcript")
                .fontWeight(.semibold)
                .padding(.top)
            Text(speech.transcript)
        }
    }
}

struct TranscriptView_Previews: PreviewProvider {
    static let speech = SpeechRecognizer()

    static var previews: some View {
        TranscriptView()
            .environmentObject(speech)
    }
}
