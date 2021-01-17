//
//  ContentView.swift
//  Sudoku
//
//  Created by Alexander Cyon on 2021-01-16.
//

import SwiftUI
import SudokuEngine

struct ContentView: View {
    @State private var appState: AppState = .playing(game: .example)
    var body: some View {
        Group { () -> AnyView in
            switch appState {
            case .setup:
                return SetupGameView { appState = .playing(game: $0) }
                    .eraseToAnyView()
            case .playing(let game):
                return gameView(game: game)
            case .finishedPlaying:
                return GameOverView {
                    appState = .setup
                }
                .eraseToAnyView()
            }
        }
    }
}

private extension ContentView {
    func gameView(game: Game) -> AnyView {
        GameView(viewModel: GameView.ViewModel(game: game)) {
            appState = .finishedPlaying
        }
        .eraseToAnyView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
