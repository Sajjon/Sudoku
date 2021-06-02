//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-06-02.
//

import Foundation

public struct Column: CellCollection, Equatable, Identifiable {
    public let index: Index
    public private(set) var cells: [Cell]
}

public extension Column {
    mutating func unsafeSetCells(newCells: [Cell]) {
        self.cells = newCells
    }
}
