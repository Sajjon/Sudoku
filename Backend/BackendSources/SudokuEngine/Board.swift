//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-01-17.
//

import Foundation

private extension Int {
    static let sudokuCellCount = 81
}

public struct Board {
    
    public private(set) var cells: [Cell]
    
    public init(cells: [Cell]) {
        precondition(cells.count == .sudokuCellCount)
        self.cells = cells
    }
    
    public init(cellFills: [Fill]) {
        precondition(cellFills.count == .sudokuCellCount)
        self.init(cells: cellFills.enumerated().map({ index, fill in
            Cell(globalIndex: index, fill: fill)
        }))
    }
    
}

internal extension Board {
  
    
    mutating func fill(
        cell: Cell,
        with fill: Fill
    ) {

        cells[cell.globalIndex] = .init(globalIndex: cell.globalIndex, fill: fill)
    }
}


public extension Board {
    
    static func allCellsFilled(with fill: Fill) -> Self {
        .init(cellFills: .init(repeating: fill, count: .sudokuCellCount))
    }
    
    static let empty: Self = .allCellsFilled(with: .empty)
    
    static let example = Self(cellFills: [
        [0, 0, 0, 0, 0, 0, 8, 0, 0],
        [0, 0, 4, 0, 0, 8, 0, 0, 9],
        [0, 7, 0, 0, 0, 0, 0, 0, 5],
        [0, 1, 0, 0, 7, 5, 0, 0, 8],
        [0, 5, 6, 0, 9, 1, 3, 0, 0],
        [7, 8, 0, 0, 0, 0, 0, 0, 0],
        [0, 2, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 9, 3, 0, 0, 1, 0],
        [0, 0, 5, 7, 0, 0, 4, 0, 3]
    ].flatMap { $0 })
}
