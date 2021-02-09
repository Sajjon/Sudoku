//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-01-17.
//

import Foundation
import Algorithms

internal extension Int {
    static let sudokuCellCountPerRegion = 9
    static let sudokuRegionCount = 9
    static var sudokuCellCount: Self {
        sudokuRegionCount * sudokuCellCountPerRegion
    }
}
public struct Region: Equatable {
    public let index: Index
    public private(set) var cells: [Cell]
    
}
internal extension Region {
    mutating func fillCell(
        at index: Cell.Index,
        with fill: Fill
    ) {
        cells.updateElement(at: index) { cell in
            cell.fill(with: fill)
        }
    }
}

public extension Region {
    typealias Index = Array<Cell>.Index
}

public struct Board {
    
    public private(set) var regions: [Region]
    
    public init(regions: [Region]) {
        precondition(regions.count == .sudokuRegionCount)
        self.regions = regions
    }
    
    public init(cellFills: [Fill]) { // [Fill] -> [(index: Index, element: Fill)]
        precondition(cellFills.count == .sudokuCellCount)
        self.init(regions:
                    cellFills.chunks(ofCount: .sudokuCellCountPerRegion).enumerated().map({
                        regionIndex, fillsOfCellsInRegion in
                        Region(index: regionIndex, cells: fillsOfCellsInRegion.enumerated().map({
                            cellIndex, fill in
                            Cell(regionIndex: regionIndex, indexWithinRegion: cellIndex, fill: fill)
                        }))
                    }))
    }
    
}

internal extension Board {
    
    
    mutating func fill(
        cell: Cell,
        with fill: Fill
    ) {
        fillCell(in: cell.regionIndex, at: cell.indexWithinRegion, with: fill)
    }
    
    
    
}

public extension Array {
    mutating func updateElement(at index: Index, _ updateElement: (inout Element) -> Void) {
        var element = self[index]
        updateElement(&element)
        self[index] = element
    }
}

private extension Board {
    mutating func fillCell(
        in regionIndex: Region.Index,
        at cellIndex: Cell.Index,
        with fill: Fill
    ) {
        regions.updateElement(at: regionIndex) { region in
            region.fillCell(at: cellIndex, with: fill)
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
