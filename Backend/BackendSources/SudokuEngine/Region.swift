//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-02-09.
//

import Foundation

public struct Region: Equatable {
    public let index: Index
    public private(set) var cells: [Cell]
    
}

internal extension Region {
    
    
    mutating func fillCell(
        at index: Cell.Index,
        with fill: Fill
    ) throws {
        var cellsCopy = cells
        cellsCopy.updateElement(at: index) { cell in
            cell.fill(with: fill)
        }
        self.cells = try checkForDuplicateDigits(in: cellsCopy, scope: .region)
    }
}

public extension Region {
    typealias Index = Array<Cell>.Index
    
    
}
