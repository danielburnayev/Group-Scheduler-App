//
//  ContentView.swift
//  Group Scheduler App
//
//  Created by Daniel Burnayev on 9/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("WOW!!!") {
                print("printed")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
