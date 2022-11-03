//
//  HomeView.swift
//  morning-app
//
//  Created by Lawrence Park on 11/2/22.
//

//
//  SwiftUIView.swift
//  morning-app
//
//  Created by Lawrence Park on 11/2/22.
//

import SwiftUI
import UIKit


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

