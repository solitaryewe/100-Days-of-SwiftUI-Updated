//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Woolly on 4/22/22.
//

import SwiftUI

struct ContentView: View {
    @State private var game: Game = Game()
    private let roundsInGame = 10
    @State private var gameDone = false
    
    @State private var score: Int = 0
    @State private var roundCount: Int = 0
    @State private var tryingToWin: Bool = Bool.random()
    
    var body: some View {
        VStack {
            Spacer()
            headerView()
            Spacer()
            HStack {
                gameMoveButton(for: .rock)
                gameMoveButton(for: .paper)
                gameMoveButton(for: .scissors)
            }
            HStack {
                gameMoveButton(for: .lizard)
                gameMoveButton(for: .spock)
            }
            Spacer()
            footerView()
            Spacer()
        }
    }
    
    @ViewBuilder func headerView() -> some View {
        if (gameDone) {
            Image("thumbsup")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            Text("Game Over!").fontWeight(.bold)
            Button(action: {restartGame()}, label: {Text("Play Again?")})
        } else {
            gameMoveImage(for: game.computerChoice)
            HStack(spacing: 0) {
                Text("Try to ")
                Text(tryingToWin ? "win" : "lose")
                    .fontWeight(.bold)
                Text(" against ")
                Text(game.computerChoice.rawValue)
                    .fontWeight(.bold)
                Text(":")
            }
        }
    }
    
    @ViewBuilder func footerView() -> some View {
        if (gameDone) {
            if (score == 10) { Text("Perfect!") }
            HStack(spacing: 0) {
                Text("Score: ")
                Text(String(score)).fontWeight(.bold)
                Text("/\(roundsInGame)")
            }
        } else {
            Text("What's your guess?")
        }
    }
    
    func gameMoveButton(for move: Move) -> some View {
        Button {
            roundCount += 1
            let won = game.winAgainstComputer(with: move)
            if ((won && tryingToWin) || (!won && !tryingToWin))  { score += 1 }
            
            if (roundCount == roundsInGame) {
                gameDone = true
                return
            }
            
            nextRound()
        } label: {
            gameMoveImage(for: move)
        }
        .disabled(gameDone ? true : false)
    }
    
    func gameMoveImage(for move: Move) -> some View {
        Image(move.rawValue.lowercased())
            .resizable()
            .scaledToFit()
            .frame(height: 100)
            .padding()
    }
    
    func nextRound() {
        // Picking a new one each time rather than toggle: more interesting.
        tryingToWin = Bool.random()
        game.newComputerChoice()
    }
    
    func restartGame() {
        nextRound()
        roundCount = 0
        score = 0
        gameDone = false
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
