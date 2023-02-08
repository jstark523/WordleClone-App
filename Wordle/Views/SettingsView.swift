//
//  SettingsView.swift
//  Wordle
//
//  Created by Jason Starkman on 2/7/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject var dm: WordleDataModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView{
            VStack{
                Toggle("HardMode", isOn: $dm.hardMode)
                Text("Change Theme")
                Picker("Display Mode", selection: $csManager.colorScheme){
                    Text("Dark").tag(ColorScheme.dark)
                    Text("Light").tag(ColorScheme.light)
                    Text("System").tag(ColorScheme.unspecified)
                }
                .pickerStyle(.segmented)
                Spacer()
            }.padding()
            .navigationTitle("Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        dismiss()
                    }
                    label:{
                        Text("**X**")
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(WordleDataModel())
            .environmentObject(ColorSchemeManager())
    }
}
