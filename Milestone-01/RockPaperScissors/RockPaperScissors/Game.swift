//
//  Game.swift
//  RockPaperScissors
//
//  Created by Woolly on 4/22/22.
//

import Foundation


struct Game {
    // We will get a Move element back, so force unwrapping is safe here.
    var computerChoice: Move = Move.allCases.randomElement()!
    mutating func newComputerChoice() {
        computerChoice = Move.allCases.randomElement()!
    }
    
    func winAgainstComputer(with humanChoice: Move) -> Bool { humanChoice.winsAgainst(computerChoice) }
}


// CaseIterable for .allCases
enum Move: String, CaseIterable {
    case rock = "rock", paper = "paper", scissors = "scissors", lizard = "lizard", spock = "Spock"
}

extension Move {
    private var winsAgainst: [Move] {
        switch self {
        case .rock: return [.lizard, .scissors]
        case .paper: return [.spock, .rock]
        case .scissors: return [.lizard, .paper]
        case .lizard: return [.spock, .paper]
        case .spock: return [.rock, .scissors]
        }
    }
    
    func winsAgainst(_ opponent: Move) -> Bool {
        return self.winsAgainst.contains(opponent)
    }
}
