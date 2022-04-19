//
//  ContentView.swift
//  Guess the Flag
//
//  Created by Woolly on 4/16/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    // Challenge 1
    @State private var score = 0
    // Challenge 3
    @State private var questionsAsked = 0
    @State private var showingEndOfGame = false
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    // Challenge 2
    @State private var userChoice = 0
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .preferredColorScheme(.light)
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            // Challenge 2
            Text((userChoice != correctAnswer ? "That's the flag of \(countries[userChoice]).\n" : "") + "Your score is \(score)." )
        }
        .alert("End of Game!", isPresented: $showingEndOfGame) {
            Button("Restart Game", action: resetGame)
        } message: {
            // Challenge 3
            Text((score == 8 ? "Perfect!\n" : "") + "Your final score for the game is \(score).")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Incorrect!"
            score -= 1
        }
        userChoice = number
        showingScore = true
    }
    
    func askQuestion() {
        questionsAsked += 1
        if (questionsAsked == 8) {
            showingEndOfGame = true
            return
        }
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    // Challenge 3
    func resetGame() {
        questionsAsked = 0
        score = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
