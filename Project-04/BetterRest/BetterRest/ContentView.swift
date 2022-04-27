//
//  ContentView.swift
//  BetterRest
//
//  Created by Woolly on 4/23/22.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Challenge 1: Replaced VStacks with Sections -- I like it.
                Section("When do you want to wake up?") {
                    // Wheel style for DatePicker looks nice in this UI.
                    DatePicker("Please enter a time:", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
            
                Section("Desired amount of sleep?") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily Coffee Intake?") {
                    // Challenge 2: Picker instead of Stepper for cups of coffee.
                    // Kept Stepper because it looks better in my opinion.
//                    Picker("How many coffees?", selection: $coffeeAmount) {
//                        ForEach(1..<21) {
//                            Text($0 == 1 ? "1 cup" : "\($0) cups")
//                        }
//                    }
                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                }
                
                // Challenge 3: UI always shows bedtime.
                // * "When the state value changes, the view invalidates its appearance and recomputes the body." *
                // Thus the function gets called again and uses the new values of the @State variables.
                Section("Your ideal bedtime is...") {
                    Text(calculateBedtime())
                        .font(.title)
                }

            }
            .navigationTitle("BetterRest")
        }
    }
    
    func calculateBedtime() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            return (wakeUp - prediction.actualSleep).formatted(date: .omitted, time: .shortened)
        } catch {
            return "Error"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
