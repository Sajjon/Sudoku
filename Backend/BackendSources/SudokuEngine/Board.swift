//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-01-17.
//

import Foundation
import Algorithms


public struct Board {
    
    public private(set) var regions: [Region]
    
    public init(regions: [Region]) {
        precondition(regions.count == .sudokuRegionCount)
        self.regions = regions
    }
    
    public init(cellFills: [Fill]) {
        precondition(cellFills.count == .sudokuCellCount)
        self.init(
            regions:
                cellFills.chunks(ofCount: .sudokuCellCountPerRegion)
                .enumerated()
                .map({ regionIndex, fillsOfCellsInRegion in
                    Region(
                        index: regionIndex,
                        cells:
                            fillsOfCellsInRegion
                            .enumerated()
                            .map({ cellIndex, fill in
                                Cell(regionIndex: regionIndex, indexWithinRegion: cellIndex, fill: fill)
                            })
                    )
                })
        )
    }
    
}

internal extension Board {
    
    mutating func fill(
        cell: Cell,
        with fill: Fill
    ) throws {
        
        todo("Implement game logic here")
        // TODO: Implement game logic here
        try fillCell(in: cell.regionIndex, at: cell.indexWithinRegion, with: fill)
    }
    
}

private extension Board {
    mutating func fillCell(
        in regionIndex: Region.Index,
        at cellIndex: Cell.Index,
        with fill: Fill
    ) throws {
        try regions.updateElement(at: regionIndex) { region in
            try region.fillCell(at: cellIndex, with: fill)
        }
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
