//
//  GameView.swift
//  Wordle
//
//  Created by Jason Starkman on 1/30/23.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var dm: WordleDataModel
    var body: some View {
        ZStack {
            NavigationView{
                VStack{
                    Spacer()
                    VStack(spacing: 3){
                        ForEach(0...5, id: \.self){index in
                            GuessView(guess: $dm.guesses[index])
                                .modifier(Shake(animatableData: CGFloat(dm.incorrectAttempts[index])))
                        }
                    }
                    .frame(width: Global.boardWidth, height: 6 * Global.boardWidth/5)
                    Spacer()
                    KeyboardView()
                        .scaleEffect(Global.keyboardScale)
                        .padding(.top)
                    Spacer()
                }
                    .navigationViewStyle(.stack)
                    .navigationBarTitleDisplayMode(.inline)
                    .overlay(alignment: .top){
                        if let toastText = dm.toastText{
                            ToastView(toastText: toastText)
                                .offset(y: 20)
                        }
                    }
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading){
                            HStack{
                                if !dm.inPlay{
                                    Button{
                                        dm.newGame()
                                    }
                                    label:{
                                        Text("New")
                                            .foregroundColor(.primary)
                                    }
                                }
                                Button{
                                    
                                }
                                label:{
                                    Image(systemName: "questionmark.circle")
                                }
                            }
                        }
                        ToolbarItem(placement: .principal){
                            Text("WORDLE")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.primary)
                        }
                        ToolbarItem(placement: .navigationBarTrailing){
                            HStack{
                                Button{
                                    dm.showStats.toggle()
                                }
                                label:{
                                    Image(systemName: "chart.bar")
                                }
                                Button{
                                    
                                }
                                label:{
                                    Image(systemName: "gearshape.fill")
                                }
                            }
                        }
                    }
            }
            if dm.showStats{
                StatsView()
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(WordleDataModel())
    }
}
