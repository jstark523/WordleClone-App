//
//  WordleApp.swift
//  Wordle
//
//  Created by Jason Starkman on 1/30/23.
//

import SwiftUI

@main
struct WordleApp: App {
    @StateObject var dm = WordleDataModel()
    @StateObject var csManager = ColorSchemeManager()
    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(dm)
                .environmentObject(csManager)
                .onAppear{
                    csManager.applyColorScheme()
                }
        }
    }
}
