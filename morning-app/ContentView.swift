//
//  ContentView.swift
//  morning-app
//
//  Created by Lawrence Park on 10/25/22.
//

import SwiftUI
import UIKit
import AudioToolbox


// code borrowed from https://tutorial101.blogspot.com/2021/06/swiftui-timer-using-circular-progress.html


struct ContentView: View {
    var body: some View {
        TabView {
            
            
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            Text("Alarm")
                .tabItem {
                    Image(systemName: "alarm")
                    Text("Alarm")
                }
            
            
            SettingsView() // Timer
                .tabItem {
                    Image(systemName: "timer")
                    Text("Timer")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

