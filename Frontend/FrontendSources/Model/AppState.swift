//
//  AppState.swift
//  FrontendSources
//
//  Created by Alexander Cyon on 2021-01-17.
//

import SudokuEngine

enum AppState {
    case setup
    case playing(game: Game)
    case finishedPlaying
}
