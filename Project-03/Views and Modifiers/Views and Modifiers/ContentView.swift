//
//  ContentView.swift
//  Views and Modifiers
//
//  Created by Woolly on 4/19/22.
//

import SwiftUI

struct BlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.blue)
            .font(.largeTitle.weight(.bold))
    }
}

extension View {
    func blueTitle() -> some View {
        modifier(BlueTitle())
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .blueTitle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
