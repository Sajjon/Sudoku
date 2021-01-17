//
//  GameView+ViewModel.swift
//  FrontendSources
//
//  Created by Alexander Cyon on 2021-01-17.
//

import SwiftUI
import SudokuEngine

extension GameView {
    final class ViewModel: ObservableObject {
        @Published var game: Game
        @Published var idOfSelectedSquare: Square.ID?
        
        init(game: Game) {
            self.game = game
        }
    }
}

extension GameView.ViewModel {
    var allSquares: [Square] {
        game.board.squares
    }
    
    
    var selectedSquare: Square? {
        guard let idOfSelectedSquare = idOfSelectedSquare else {
            return nil
        }
        return allSquares[idOfSelectedSquare]
    }
}
