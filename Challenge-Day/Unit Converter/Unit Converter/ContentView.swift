//
//  ContentView.swift
//  Unit Converter
//
//  Created by Woolly on 4/14/22.
//

import SwiftUI

struct ContentView: View {
    @State private var inputValue: Double = 0
    
    // Multiple unit types as Dimensions courtesy of solution video.
    let conversionTypes = ["Temperature", "Length", "Time", "Volume"]
    @State private var selectedUnits = 0
    let units: [[Dimension]] = [
        [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin],
        [UnitLength.meters, UnitLength.kilometers, UnitLength.feet, UnitLength.yards, UnitLength.miles],
        [UnitDuration.seconds, UnitDuration.minutes, UnitDuration.hours],
        [UnitVolume.milliliters, UnitVolume.liters, UnitVolume.cups, UnitVolume.pints, UnitVolume.gallons]
    ]
    
    @State private var inputUnit: Dimension = UnitTemperature.celsius
    @State private var outputUnit: Dimension = UnitTemperature.fahrenheit
    
    @FocusState private var inputIsFocused: Bool
    
    // MeasurementFormatter courtesy of solution video.
    let formatter: MeasurementFormatter
    init() {
        formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .short
    }
    
    var result: String {
        let outputMeasurement = Measurement(value: inputValue, unit: inputUnit).converted(to: outputUnit)
        return formatter.string(from: outputMeasurement)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount to Convert", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputIsFocused)
                } header: {
                    Text("Amount to Convert")
                }
                
                Section {
                    Picker("Conversion", selection: $selectedUnits) {
                        ForEach(0..<conversionTypes.count) {
                            Text(conversionTypes[$0])
                        }
                    }

                    Picker("Convert from Unit", selection: $inputUnit) {
                        ForEach(units[selectedUnits], id: \.self) {
                            Text(formatter.string(from: $0).capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
     
                    Picker("Convert to Unit", selection: $outputUnit) {
                        ForEach(units[selectedUnits], id: \.self) {
                            Text(formatter.string(from: $0).capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Text(result)
                } header: {
                    Text("Result")
                }
            }
            .navigationTitle("Unit Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        inputIsFocused = false
                    }
                }
            }
            .onChange(of: selectedUnits) { newUnits in
                inputUnit = units[newUnits][0]
                outputUnit = units[newUnits][1]
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
