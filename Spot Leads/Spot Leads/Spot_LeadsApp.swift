//
//  Spot_LeadsApp.swift
//  Spot Leads
//
//  Created by Spot on 7/26/22.
//

import SwiftUI

@main
struct Spot_LeadsApp: App {
    @StateObject var speech = SpeechRecognizer()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MenuView()
            }
            .environmentObject(speech)
        }
    }
}
