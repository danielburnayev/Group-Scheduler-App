//
//  ContentView.swift
//  Group Scheduler App
//
//  Created by Daniel Burnayev on 9/3/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: proxy.size.height / 25.3) {
                Text("Scheduler App")
                    .font(.system(size: proxy.size.width / 6.55))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, proxy.size.height / 18)
                
                Button("Create Schedule") {
                    let now = Date()
                    let formatter = DateFormatter()
                    formatter.timeZone = TimeZone.current
                    formatter.dateFormat = "yyyy-MM-dd EEE"
                    let dateString = formatter.string(from: now)
                    print(dateString)
                }
                .padding(25)
                .background(Color(red: 217/255, green: 217/255, blue: 52/255, opacity: 1.0))
                .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.85))
                .font(.system(size: proxy.size.width / 13.1)) //og font size 30
                .cornerRadius(12.5)
                
                Button("Join Schedule") {
                    
                }
                .padding(25.0)
                .background(Color(red: 84/255, green: 215/255, blue: 255/255, opacity: 1.0))
                .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.85))
                .font(.system(size: proxy.size.width / 13.1)) //og font size 30
                .cornerRadius(12.5)
                
                Button("Preivous Schedules") {
                    print("Pull up previous schedules \(proxy.size.width)x\(proxy.size.height)")
                }
                .padding(25.0)
                .background(Color.green)
                .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.85))
                .font(.system(size: proxy.size.width / 13.1)) //og font size 30
                .cornerRadius(12.5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .background(Color(red: 152/255, green: 255/255, blue: 177/255, opacity: 1.0))
        }
    }
}

#Preview {
    ContentView()
}
