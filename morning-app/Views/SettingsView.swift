//
//  TimerView.swift
//  morning-app
//
//  Created by Lawrence Park on 11/2/22.
//

// code borrowed from https://tutorial101.blogspot.com/2021/06/swiftui-timer-using-circular-progress.html


import SwiftUI

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

