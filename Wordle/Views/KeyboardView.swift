//
//  KeyboardView.swift
//  Wordle
//
//  Created by Jason Starkman on 1/31/23.
//

import SwiftUI

struct KeyboardView: View {
    @EnvironmentObject var dm: WordleDataModel
    var topRowArray = "QWERTYUIOP".map{String($0)}
    var midRowArray = "ASDFGHJKL".map{String($0)}
    var botRowArray = "ZXCVBNM".map{String($0)}
    var body: some View {
        VStack{
            HStack(spacing: 2){
                ForEach(topRowArray, id: \.self){letter in
                    LetterButtonView(letter:letter)
                }
                .disabled(dm.disabledKeys)
                .opacity(dm.disabledKeys ? 0.6:1)
            }
            HStack(spacing: 2){
                ForEach(midRowArray, id: \.self){letter in
                    LetterButtonView(letter:letter)
                }
                .disabled(dm.disabledKeys)
                .opacity(dm.disabledKeys ? 0.6:1)
            }
            HStack(spacing: 2){
                Button{
                    dm.enterWord()
                }
                label:{
                    Text("Enter")
                }
                .font(.system(size: 20))
                .frame(width: 60, height: 50)
                .foregroundColor(.primary)
                .background(Color.unused)
                .disabled(dm.currentWord.count < 5 || !dm.inPlay)
                .opacity(dm.currentWord.count < 5 || !dm.inPlay ? 0.6:1)
                ForEach(botRowArray, id: \.self){letter in
                    LetterButtonView(letter:letter)
                }
                .disabled(dm.disabledKeys)
                .opacity(dm.disabledKeys ? 0.6:1)
                Button{
                    dm.removeLetter()
                }
                label:{
                    Image(systemName: "delete.backward.fill")
                }
                .font(.system(size: 20, weight: .heavy))
                .frame(width: 40, height: 50)
                .foregroundColor(.primary)
                .background(Color.unused)
                .disabled(dm.currentWord.count == 0 || !dm.inPlay)
                .opacity(dm.currentWord.count == 0 || !dm.inPlay ? 0.6:1)
            }
        }
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView()
            .environmentObject(WordleDataModel())
            .scaleEffect(Global.keyboardScale)
    }
}
