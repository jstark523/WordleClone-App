//
//  Guess.swift
//  Wordle
//
//  Created by Jason Starkman on 1/30/23.
//

import SwiftUI

struct Guess{
    let index: Int
    var word = "     "
    var bgColors = [Color](repeating: .wrong, count: 5)
    var cardFlipped = [Bool](repeating: false, count: 5)
    var guessLetters: [String]{
        word.map{ String($0) }
    }
/*Wordle 598 3/6
    ⬛🟨🟨⬛⬛
    🟨🟨⬛⬛⬛
    🟩🟩🟩🟩🟩
 */
    var results: String{
        let tryColors: [Color:String] = [.misplaced: "🟨", .correct: "🟩", .wrong: "⬛"]
        return bgColors.compactMap{tryColors[$0]}.joined(separator: "")
    }
}
