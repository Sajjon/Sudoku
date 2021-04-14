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

public extension Board {
    
    var rows: [Row] {
        []
    }
}


//private enum ScopeToCheck: Int, Equatable {
//    case column, row, region
//}


internal extension Board {
    
    mutating func fill(
        cell: Cell,
        with fill: Fill
    ) throws {
        let columns = column(of: cell)
        let rows = row(of: cell)
        let region = regions[cell.regionIndex].cells
        
//        let cellCollectionsToCheckForDuplicates: [(cells: [Cell], scopeToCheck: Scope)] = [
//            (cells: columns, scopeToCheck: .column),
//            (cells: rows, scopeToCheck: .row),
//            (cells: region, scopeToCheck: .region)
//        ]
//
//        for cellCollectionToCheck in cellCollectionsToCheckForDuplicates {
//            print("🔮 cell indices: \(cellCollectionToCheck.cells.map({ $0.globalIndex })), scope: \(cellCollectionToCheck.scopeToCheck.rawValue)")
//            try checkForDuplicateDigits(
//                in: cellCollectionToCheck.cells,
//                scope: cellCollectionToCheck.scopeToCheck
//            )
//        }
        
        try fillCell(in: cell.regionIndex, at: cell.indexWithinRegion, with: fill)
    }
    
}

private func indexWithinRegionOfCell(_ aCell: Cell) -> Cell.Index {
    return aCell.indexWithinRegion
}

extension Array where Element: Equatable {
    
    
    func elements(
        indexOfSelectedElement: Index,
        boundedBy bound: Index,
        keyPath: KeyPath<(quotient: Int, remainder: Int), Int>
    ) -> [Element] {
        
        let indexOfSelectedElementQR = indexOfSelectedElement.quotientAndRemainder(dividingBy: bound)
        let indexOfSelectedElementQoR = indexOfSelectedElementQR[keyPath: keyPath]
        
        let indices = enumerated()
            .map({ $0.offset })
            .map({ $0.quotientAndRemainder(dividingBy: bound) })
            .map({ $0[keyPath: keyPath] })
            .filter({ $0 == indexOfSelectedElementQoR })
        
        return indices.map { self[$0] }
    }
    
    func column(
        indexOfSelectedElement: Index,
        boundedBy bound: Index
    ) -> [Element] {
        elements(
            indexOfSelectedElement: indexOfSelectedElement,
            boundedBy: bound,
            keyPath: \.remainder
        )
    }
    
    func row(
        indexOfSelectedElement: Index,
        boundedBy bound: Index
    ) -> [Element] {
        elements(
            indexOfSelectedElement: indexOfSelectedElement,
            boundedBy: bound,
            keyPath: \.quotient
        )
    }
}

extension Region {
    
    func cellsInSameColumnAs(columnIndex: Cell.Index) -> [Cell] {
        cells.column(indexOfSelectedElement: columnIndex, boundedBy: Region.columnCount)
    }
    
    func cellsInSameRowAs(rowIndex: Cell.Index) -> [Cell] {
        cells.row(indexOfSelectedElement: rowIndex, boundedBy: Region.rowCount)
    }
}

private extension Board {
    
    /// The number of region collections vertically stacked on the board.
    static let rowCount = 3
    
    /// The number of region collections horizontally aligned on the board.
    static let columnCount = 3
    
    func column(of cell: Cell) -> Column {
        
        let columns = regions.column(
            indexOfSelectedElement: cell.regionIndex,
            boundedBy: Self.columnCount
        )
        
        return columns.flatMap { region in region.cellsInSameColumnAs(columnIndex: cell.columnIndex) }
    }
    
    func row(of cell: Cell) -> Row {
        
//        let rows = regions.row(
//            indexOfSelectedElement: cell.regionIndex,
//            boundedBy: Self.rowCount
//        )
//
//        return rows.flatMap { region in region.cellsInSameRowAs(rowIndex: cell.rowIndex) }
        fatalError()
    }
    
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
    typealias Column = [Cell]
    
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
