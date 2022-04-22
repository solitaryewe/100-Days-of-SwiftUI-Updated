//
//  ContentView.swift
//  WeSplit
//
//  Created by Woolly on 4/12/22.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
    // Bonus Challenge
    let currencyCode: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currencyCode ?? "USD")
    
    // Challenge 2
    var totalCheckAmount: Double {
        return (checkAmount + (Double(tipPercentage)/100 * checkAmount))
    }
    var totalPerPerson: Double {
        return (totalCheckAmount / Double(numberOfPeople))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Check Amount", value: $checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(2..<100, id: \.self) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        //ForEach(tipPercentages, id: \.self) {
                        // Challenge 3
                        ForEach(0..<101, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    //.pickerStyle(.segmented)
                } header: {
                    Text("Tip Amount")
                }
                
                Section {
                    Text(totalPerPerson, format: currencyCode)
                } header: {
                    // Challenge 1
                    Text("Amount per Person")
                }
                
                Section {
                    Text(totalCheckAmount, format: currencyCode)
                    // Project 3, Challenge 1
                        .foregroundColor(tipPercentage == 0 ? .red : .black)
                } header: {
                    // Challenge 2
                    Text("Total Check Amount")
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
