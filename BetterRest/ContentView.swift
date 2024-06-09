//
//  ContentView.swift
//  BetterRest
//
//  Created by Emile Mathieu on 07/06/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var hoursOfSleep: Float = 0.0
    @State private var dailyCoffeeIntake = 0
    @State private var dateSelected: Date = {
            var calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: Date())
            components.hour = 6
            components.minute = 0
            return calendar.date(from: components) ?? Date()
        }()
    
    var body: some View {
        VStack(spacing: 40) {
            VStack {
                Text("When do you wake up ?").font(.headline)
                DatePicker("Selected Date", selection: $dateSelected, displayedComponents: .hourAndMinute)
                    .labelsHidden()
            }
            
            VStack {
                Text("Desired amount of sleep:").font(.headline)
                Stepper("\(hoursOfSleep.formatted()) hours", value:$hoursOfSleep, in: 1...12, step: 0.25)
            }
            
            VStack {
                Text("Cups of coffee a day").font(.headline)
                Stepper("\(dailyCoffeeIntake) cups", value: $dailyCoffeeIntake, step:1)
                
            }
        }.padding()
    }
}

#Preview {
    ContentView()
}
