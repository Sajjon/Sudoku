//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-04-14.
//

import Foundation

public protocol CellCollection {
    var index: Index { get }
    var cells: [Cell] { get }
    
    mutating func fillCell(
        at index: Cell.Index,
        with fill: Fill
    ) throws
    
    mutating func unsafeSetCells(newCells: [Cell])
}

public extension CellCollection {
    typealias Index = Array<Cell>.Index
}

public extension CellCollection {
    
    mutating func fillCell(
        at index: Cell.Index,
        with fill: Fill
    ) throws {
        var cellsCopy = cells
        cellsCopy.updateElement(at: index) { cell in
            cell.fill(with: fill)
        }
        unsafeSetCells(newCells: try checkForDuplicateDigits(in: cellsCopy, scope: .region))
    }
}

// MARK: Identifiable
public extension CellCollection {
    typealias ID = Index
    var id: ID { index }
}
