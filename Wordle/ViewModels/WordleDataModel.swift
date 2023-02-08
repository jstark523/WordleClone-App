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
    @Published var toastText: String?
    @Published var showStats = false
    
    var keyColors = [String: Color]()
    var matchedLetters = [String]()
    var misplacedLetters = [String]()
    var selectedWord = ""
    var currentWord = ""
    var tryIndex = 0
    var inPlay = false
    var gameOver = false
    var toastWords = ["Genius", "Magnificent", "Impressive", "Splendid", "Great", "Phew."]
    var currentStat: Statistic
    
    var gameStarted: Bool{
        !currentWord.isEmpty || tryIndex > 0
    }
    
    var disabledKeys: Bool{
        !inPlay || currentWord.count == 5
    }
    
    //MARK: Setup
    init(){
        currentStat = Statistic.loadStat()
        newGame()
    }
    
    func newGame(){
        populateDefaults()
        selectedWord = Global.commonWords.randomElement()!
        currentWord = ""
        inPlay = true
        tryIndex = 0
        gameOver = false
        print(selectedWord)
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
        matchedLetters = []
        misplacedLetters = []
    }

    //MARK: Gameplay
    func addToCurrentWord(letter: String){
        currentWord += letter
        updateRow()
    }
    
    func enterWord(){
        if currentWord == selectedWord{
            gameOver = true
            currentStat.update(win: true, index: tryIndex)
            showToast(text: toastWords[tryIndex])
            print("You Win")
            setCurrentGuessColors()
            inPlay = false
        }
        else{
            
            
            if verifyWord(){
                print("valid word")
                setCurrentGuessColors()
                tryIndex += 1
                currentWord = ""
                if tryIndex == 6{
                    gameOver = true
                    inPlay = false
                    currentStat.update(win: false)
                    showToast(text: selectedWord)
                }
            }
            else{
                withAnimation{
                    self.incorrectAttempts[tryIndex] += 1
                }
                showToast(text: "Not in word list.")
                incorrectAttempts[tryIndex] = 0
            }
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
    
    func setCurrentGuessColors(){
        let correctLetters = selectedWord.map{String($0)}
        var frequency = [String: Int]()
        for letter in correctLetters {
            frequency[letter, default:0] += 1
        }
        for index in 0...4{
            let correctLetter = correctLetters[index]
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if guessLetter == correctLetter{
                guesses[tryIndex].bgColors[index] = .correct
                if(!matchedLetters.contains(guessLetter)){
                    matchedLetters.append(guessLetter)
                    keyColors[guessLetter] = .correct
                }
                if(misplacedLetters.contains(guessLetter)){
                    if let index = misplacedLetters.firstIndex(where: {$0 == guessLetter}){
                        misplacedLetters.remove(at: index)
                    }
                }
                frequency[guessLetter]! -= 1
            }
        }
        for index in 0...4{
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if correctLetters.contains(guessLetter)
                && guesses[tryIndex].bgColors[index] != .correct
                && frequency[guessLetter]! > 0  {
                guesses[tryIndex].bgColors[index] = .misplaced
                if !misplacedLetters.contains(guessLetter) && !matchedLetters.contains(guessLetter){
                    misplacedLetters.append(guessLetter)
                    keyColors[guessLetter] = .misplaced
                }
                frequency[guessLetter]! -= 1
            }
        }
        for index in 0...4{
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if (keyColors[guessLetter] != .correct
                && keyColors[guessLetter] != .misplaced){
                keyColors[guessLetter] = .wrong
            }
        }
        flipCards(row: tryIndex)
    }
    
    func flipCards(row: Int){
        for col in 0...4{
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(col) * 0.2){
                self.guesses[row].cardFlipped[col].toggle()
            }
        }
    }
    
    func showToast(text: String?){
        withAnimation{
            toastText = text
        }
        withAnimation(Animation.linear(duration: 0.2).delay(3)){
            toastText = nil
            if gameOver {
                withAnimation(Animation.linear(duration: 0.2).delay(3)){
                    showStats.toggle()
                }
            }
        }
    }
    /*Wordle 598 3/6
        ⬛🟨🟨⬛⬛
        🟨🟨⬛⬛⬛
        🟩🟩🟩🟩🟩
     */
    func shareResult(){
        let stat = Statistic.loadStat()
        let resultString = """
Wordle \(stat.games) \(tryIndex < 6 ? "\(tryIndex + 1)/6" : "")
\(guesses.compactMap{$0.results}.joined(separator: "\n"))
"""
        let activityController = UIActivityViewController(activityItems: [resultString], applicationActivities: nil)
        switch UIDevice.current.userInterfaceIdiom{
        case .phone:
            UIWindow.key?.rootViewController!
                .present(activityController, animated: true)
        case .pad:
            activityController.popoverPresentationController?.sourceView = UIWindow.key
            activityController.popoverPresentationController?.sourceRect = CGRect(x: Global.screenWidth / 2, y: Global.screenHeight / 2, width: 200, height: 200)
            UIWindow.key?.rootViewController!
                .present(activityController, animated: true)
        default:
            break
        }
    }
}
