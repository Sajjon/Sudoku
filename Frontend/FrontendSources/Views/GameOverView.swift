//
//  GameOverView.swift
//  FrontendSources
//
//  Created by Alexander Cyon on 2021-01-17.
//

import SwiftUI

struct GameOverView: View {
    let setupNewGame: () -> Void
    var body: some View {
        VStack {
            Text("Game over")
            Button("Setup new game", action: setupNewGame)
        }
            .navigationTitle("Setup Game")
    }
}

