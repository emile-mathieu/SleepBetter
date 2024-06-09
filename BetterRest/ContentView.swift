//
//  ContentView.swift
//  BetterRest
//
//  Created by Emile Mathieu on 07/06/2024.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var hoursOfSleep: Double = 0.0
    @State private var dailyCoffeeIntake: Int = 0
    @State private var dateSelected: Date = {
            var calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute], from: Date())
            components.hour = 6
            components.minute = 0
            return calendar.date(from: components) ?? Date()
        }()
    
    func calculateBedTime() -> Void {
        do {
            let config = MLModelConfiguration()
            let model = try SleepBetter(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from:dateSelected)
            
            let hour = (components.hour ?? 0) * 60 * 60
            let mins =  (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + mins), estimatedSleep: hoursOfSleep, coffee: Double(dailyCoffeeIntake))
            
            let sleepTime = dateSelected - prediction.actualSleep
            
            alertTitle = "Your ideal beditme is:"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            isShowingAlert = true
        } catch {
            //Need this in case something went wrong here
            alertTitle = "Error"
            alertMessage = "Sorry something went wrong!"
        }
        
    }

    var body: some View {
        NavigationStack {
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
                .navigationTitle("Sleep Better")
                .toolbar {
                    Button("Calculate", action: calculateBedTime)
                }
                .alert(alertTitle, isPresented: $isShowingAlert, actions: {
                    Button("OK", action: { isShowingAlert = false})
                }, message: {
                    Text(alertMessage)
                })
        }
    }
}

#Preview {
    ContentView()
}
