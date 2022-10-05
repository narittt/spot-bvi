//
//  VoiceView.swift
//  Spot Leads
//
//  Created by Spot on 7/27/22.
//

import SwiftUI

struct VoiceView: View {
    let history: History

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Live Transcript")
                    .font(.headline)
                    .padding(.top)
                if let transcript = history.transcript {
                    
                    Text(transcript)
                }
            }
        }
    }
}


struct HistoryView_Previews: PreviewProvider {
    static var history: History {
        History(transcript: "Darla, would you like to start today? Sure, yesterday I reviewed Luis' PR and met with the design team to finalize the UI...")
    }
    
    static var previews: some View {
        VoiceView(history: history)
    }
}

