//
//  SetupGameView.swift
//  FrontendSources
//
//  Created by Alexander Cyon on 2021-01-17.
//

import SwiftUI
import SudokuEngine

struct SetupGameView: View {
    let didStartGame: (Game) -> Void
    var body: some View {
        VStack {
            
            Text("Welcome to Sudoku, an awesome game!")
            
            Button("Start Game") {
                self.didStartGame(.example)
            }
        }
            .navigationTitle("Setup Game")
    }
}
