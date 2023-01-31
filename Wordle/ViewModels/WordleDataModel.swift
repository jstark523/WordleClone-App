//
//  WordleDataModel.swift
//  Wordle
//
//  Created by Jason Starkman on 1/30/23.
//

import SwiftUI

class WordleDataModel: ObservableObject{
    @Published var guesses: [Guess] = []
    @Published var incorrectAttempts = [Int](repeating: 0, count: 6)
    
    var keyColors = [String: Color]()
    var selectedWord = ""
    var currentWord = ""
    var tryIndex = 0
    var inPlay = false
    
    var gameStarted: Bool{
        !currentWord.isEmpty || tryIndex > 0
    }
    
    var disabledKeys: Bool{
        !inPlay || currentWord.count == 5
    }
    
    //MARK: Setup
    init(){
        newGame()
    }
    
    func newGame(){
        populateDefaults()
        selectedWord = Global.commonWords.randomElement()!
        currentWord = ""
        inPlay = true
    }

    func populateDefaults(){
        guesses = []
        for index in 0...5{
            guesses.append(Guess(index: index))
        }
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for char in letters{
            keyColors[String(char)] = .unused
        }
    }

    //MARK: Gameplay
    func addToCurrentWord(letter: String){
        currentWord += letter
        updateRow()
    }
    
    func enterWord(){
        if verifyWord(){
            print("valid word")
        }
        else{
            withAnimation{
                self.incorrectAttempts[tryIndex] += 1
            }
            incorrectAttempts[tryIndex] = 0
        }
    }
    
    func removeLetter(){
        currentWord.removeLast()
        updateRow()
    }
    
    func updateRow(){
        let guessWord = currentWord.padding(toLength: 5, withPad: " ", startingAt: 0)
        guesses[tryIndex].word = guessWord
    }
    
    func verifyWord() -> Bool{
        UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: currentWord)
    }
}
