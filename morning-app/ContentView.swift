//
//  ContentView.swift
//  morning-app
//
//  Created by Lawrence Park on 10/25/22.
//

import SwiftUI
import UIKit
import AudioToolbox

struct HomeView: View {
    
    @State var currentTime = Time(hour: 0, minute: 0, second: 0)
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    var width = UIScreen.main.bounds.width
    
    var body: some View {
        
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), center: .center, startRadius: 5, endRadius: 500)
                .scaleEffect(1.5)
            
            VStack {
                Text(getTime())
                    .font(.system(size: 45))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                        .opacity(0.01)
                    
                    Spacer()
                    
                    ForEach (0..<60, id: \.self) {i in
                        Rectangle()
                            .fill(Color.primary)
                            .frame(width: 2, height: (i % 5) == 0 ? 15 : 5)
                            .offset(y: (width - 110) / 2)
                            .rotationEffect(.init(degrees: Double(i) * 6))
                    }
                    
                    //Minute
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 4, height: (width - 150) / 2)
                        .offset(y: (-(width - 200) / 4))
                        .rotationEffect(.init(degrees: Double(currentTime.minute) * 6))
                    
                    //Hour
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 4.5, height: (width - 240) / 2)
                        .offset(y: -(width - 240) / 4)
                        .rotationEffect(.init(degrees: Double(currentTime.hour + currentTime.minute / 60) * 30))
                    
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: 2, height: (width - 180) / 2)
                        .offset(y: -(width - 180) / 4)
                        .rotationEffect(.init(degrees: Double(currentTime.second) * 6))
                    
                    Circle()
                        .fill(Color.primary)
                        .frame(width: 15, height: 15)
                }
                .frame(width: width - 100, height: width - 100)
            }
            .onAppear(perform: {
                let calendar = Calendar.current
                
                let sec = calendar.component(.second, from: Date())
                let min = calendar.component(.minute, from: Date())
                let hour = calendar.component(.hour, from: Date())
                
                withAnimation(Animation.linear(duration: 0.01)) {
                    currentTime = Time(hour: hour, minute: min, second: sec)
                }
                
                
            })
            
            .onReceive(receiver) { _ in
                let calendar = Calendar.current
                
                let sec = calendar.component(.second, from: Date())
                let min = calendar.component(.minute, from: Date())
                let hour = calendar.component(.hour, from: Date())
                
                withAnimation(Animation.linear(duration: 0.01)) {
                    currentTime = Time(hour: hour, minute: min, second: sec)
                }
                
            }
            
        }
        
    }
func getTime() -> String {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        return format.string(from: Date())
    }
}

struct Time {
    var hour: Int
    var minute: Int
    var second: Int
}


// code borrowed from https://tutorial101.blogspot.com/2021/06/swiftui-timer-using-circular-progress.html

let time = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()


struct SettingsView: View { // grace period timer - 3 minutes
    
    
    
    @State var counter: Int = 0
    var countTo: Int = 180 //4 minutes 120 - 2minutes
    
    var body: some View {
        
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), center: .center, startRadius: 5, endRadius: 500)
                .scaleEffect(1.5)
            
            VStack{
                NavigationView {
                    
                    ZStack{
                        
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 250, height: 250)
                            .overlay(
                                Circle().stroke(Color.purple, lineWidth: 25)
                            )
                        
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 250, height: 250)
                            .overlay(
                                Circle().trim(from:0, to: progress())
                                    .stroke(
                                        style: StrokeStyle(
                                            lineWidth: 25,
                                            lineCap: .round,
                                            lineJoin:.round
                                        )
                                    )
                                    .foregroundColor(
                                        (completed() ? Color.orange : Color.orange)
                                    ).animation(Animation.easeInOut(duration: 0.2).repeatForever(), value: 0)
                                
                                
                                
                            )
                        
                        Clock(counter: counter, countTo: countTo)
                    }
                    .navigationTitle("Timer")
                }
                
            }
            
            .onReceive(timer) { time in
                if (self.counter < self.countTo) {
                    self.counter += 1
                }
            }
        }
        
    }
        func completed() -> Bool {
            return progress() == 1
        }
        
        func progress() -> CGFloat {
            return (CGFloat(counter) / CGFloat(countTo))
        
    }
}
 
struct ClockView: View {
    var counter: Int
    var countTo: Int
     
    var body: some View {
        VStack {
            Text(counterToMinutes())
                .font(.system(size: 60))
                .fontWeight(.black)
        }
    }
     
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)
         
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            
            Text("Alarm")
                .tabItem {
                    Image(systemName: "alarm")
                    Text("Alarm")
                }
            
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
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

