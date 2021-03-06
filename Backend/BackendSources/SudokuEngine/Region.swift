//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-02-09.
//

import Foundation

public struct Region: CellCollection, Equatable, Identifiable {
    public let index: Index
    public private(set) var cells: [Cell]
}

public extension Region {

    
    mutating func unsafeSetCells(newCells: [Cell]) {
        self.cells = newCells
    }
    static let rowCount = 3
    static let columnCount = 3
}

