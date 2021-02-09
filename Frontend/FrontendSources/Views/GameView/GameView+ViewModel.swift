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
        @Published var idOfSelectedCell: Cell.ID?
        
        init(game: Game) {
            self.game = game
        }
    }
}

extension GameView.ViewModel {
    var allCells: [Cell] {
        game.board.regions.flatMap {
            $0.cells
        }
    }
    
    var numberOfFills: UInt {
        game.numberOfFills
    }
    
    var selectedCell: Cell? {
        guard let idOfSelectedCell = idOfSelectedCell else {
            return nil
        }
        return allCells[idOfSelectedCell]
    }
    
    func userDidSelectFill(_ fill: Fill) {
        guard let selectedCell = selectedCell else { return }
        do {
            try game.fill(cell: selectedCell, with: fill)
        } catch {
            print("☢️ ERROR: \(error)")
        }
    }
    
    var isAnyCellSelected: Bool {
        selectedCell != nil
    }
}
