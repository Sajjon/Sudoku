//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-04-14.
//

import Foundation

public struct Row: CellCollection, Equatable, Identifiable {
    public let index: Index
    public private(set) var cells: [Cell]
}

public extension Row {
    mutating func unsafeSetCells(newCells: [Cell]) {
        self.cells = newCells
    }
}
