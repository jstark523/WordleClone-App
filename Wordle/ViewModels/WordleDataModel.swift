//
//  WordleDataModel.swift
//  Wordle
//
//  Created by Jason Starkman on 1/30/23.
//

import SwiftUI

class WordleDataModel: ObservableObject{
    @Published var guesses: [Guess] = []
    
    var keyColors = [String: Color]()
    
    //MARK: Setup
    init(){
        newGame()
    }
    
    func newGame(){
        populateDefaults()
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
        
    }
    
    func enterWord(){
        
    }
    
    func removeLetter(){
        
    }
}
