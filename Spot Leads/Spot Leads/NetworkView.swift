//
//  NetworkView.swift
//  Spot Leads
//
//  Created by Spot on 7/26/22.
//

import SwiftUI
import Network

struct NetworkView: View {
    
    @State private var connection: NWConnection?
    private var host: NWEndpoint.Host = "192.168.80.100"
    private var port: NWEndpoint.Port = 12345
    
    
    var body: some View {
        List {
            Section(header: Text("IP Address")){
                Text("137.146.127.239")
            }
            Section(header: Text("Test Connection")) {
                HStack {
                    Button("Connect to Server") {
                        NSLog("Connect pressed")
                        connect()
                    }
                }
            }
            Section(header: Text("Send a Test Message")) {
                HStack {
                    Button("Send a Message") {
                        NSLog("Send prssed")
                        send("backwards".data(using: .utf8)!)
                    }
                }
            }
        }
        .navigationTitle("Network Settings")
    }
    
    func send(_ payload: Data) {
        connection!.send(content: payload, completion: .contentProcessed({ sendError in
            if let error = sendError {
                NSLog("Unable to process and send the data: \(error)")
            } else {
                NSLog("Data has been sent")
                connection!.receiveMessage { (data, context, isComplete, error) in
                    guard let myData = data else { return }
                    NSLog("Received message: " + String(decoding: myData, as: UTF8.self))
                }
            }
        }))
    }
    
    func connect() {
        connection = NWConnection(host: host, port: port, using: .udp)
        
        connection!.stateUpdateHandler = { (newState) in
            switch (newState) {
            case .preparing:
                NSLog("Entered state: preparing")
            case .ready:
                NSLog("Entered state: ready")
            case .setup:
                NSLog("Entered state: setup")
            case .cancelled:
                NSLog("Entered state: cancelled")
            case .waiting:
                NSLog("Entered state: waiting")
            case .failed:
                NSLog("Entered state: failed")
            default:
                NSLog("Entered an unknown state")
            }
        }
        
        connection!.viabilityUpdateHandler = { (isViable) in
            if (isViable) {
                NSLog("Connection is viable")
            } else {
                NSLog("Connection is not viable")
            }
        }
        
        connection!.betterPathUpdateHandler = { (betterPathAvailable) in
            if (betterPathAvailable) {
                NSLog("A better path is availble")
            } else {
                NSLog("No better path is available")
            }
        }
        
        connection!.start(queue: .global())
    }
}

struct NetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NetworkView()
        }
    }
}
