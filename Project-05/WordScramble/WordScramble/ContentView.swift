//
//  ContentView.swift
//  WordScramble
//
//  Created by Woolly on 4/29/22.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                        .onSubmit(addNewWord)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
        }
        // Challenge 2: restart game with new word
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Restart Game") {
                    restartGame()
                }
                // Challenge 3: show score
                Text("Score: \(score)")
            }
        }
        .onAppear(perform: startGame)
        .alert(errorTitle, isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    // Challenge 2: restart game with new word
    func restartGame() {
        startGame()
        usedWords = [String]()
        newWord = ""
        score = 0
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
//        guard answer.count > 0 else { return }
        
        // Challenge 1: not starting word
        guard isNotStartWord(word: answer) else {
            wordError(title: "That's The Start Word", message: "You can't just use the start word!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word Not Possible", message: "That word can't be spelled from \(rootWord)!")
            return
        }
        
        // Challenge 1: word greater than 3 letters
        guard isLongEnough(word: answer) else {
            wordError(title: "Word Too Short", message: "The word must be greater then 3 letters!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word Not Recognized", message: "That's not a valid English word!")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word Used Already", message: "Choose a different word!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
        
        // Challenge 3: score for game, just add 1 for a word and the number of letters in the word the user found
        score += answer.count + 1
    }
    
    // original, possible, real
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                // Found
                tempWord.remove(at: position)
            } else {
                // Not in rootWord
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    // Challenge 1: word greater than 3 letters
    func isLongEnough(word: String) -> Bool {
        if (word.count > 3) {
            return true
        }
        return false
    }
    
    // Challenge 1: not starting word
    func isNotStartWord(word: String) -> Bool {
        if (word != rootWord) {
            return true
        }
        return false
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
