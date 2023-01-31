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
        NavigationView{
            VStack{
                Spacer()
                VStack(spacing: 3){
                    ForEach(0...5, id: \.self){index in
                        GuessView(guess: $dm.guesses[index])
                    }
                }
                .frame(width: Global.boardWidth, height: 6 * Global.boardWidth/5)
                Spacer()
                KeyboardView()
                    .scaleEffect(Global.keyboardScale)
                    .padding(.top)
                Spacer()
            }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button{
                            
                        }
                    label:{
                            Image(systemName: "questionmark.circle")
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
        .navigationViewStyle(.stack)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(WordleDataModel())
    }
}
