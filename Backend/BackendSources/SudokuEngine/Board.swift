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

//public extension Board {
//
//
//    func regionsForRow(at rowIndex: Int) -> [Region] {
//
//        rowIndex.quotientAndRemainder(dividingBy: Board)
//
//        let lowerRegionIndex = 0 // FIXME calculate this
//        let upperRegionIndex = 0 // FIXME calculate this
//
//        return (lowerRegionIndex..<upperRegionIndex).map({ regionIndex in
//            self.regions[regionIndex]
//        })
//    }
//
//    var rows: [Row] {
//        let rows: [Row] = (0..<Board.rowCount).map({ (rowIndex: Int) -> Row in
//            let regions = regionsForRow(at: rowIndex)
//            let cells: [Cell] = regions.flatMap({ (region: Region) -> [Cell] in
//                region.cellsInSameRowAs(rowIndex: rowIndex)
//            })
//
//            return Row(index: rowIndex, cells: cells)
//        })
//
//        return rows
//    }
//}


//private enum ScopeToCheck: Int, Equatable {
//    case column, row, region
//}


internal extension Board {
    
    mutating func fill(
        cell: Cell,
        with fill: Fill
    ) throws {
        let column = column(of: cell)
        let row = row(of: cell)
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
        
//        try fillCell(in: cell.regionIndex, at: cell.indexWithinRegion, with: fill)
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

        let indices = enumerated()
            .map { (offset: Int, element: Element) in
                return offset
            }
            .compactMap({ (offset: Int) -> Int? in
                let qr = offset.quotientAndRemainder(dividingBy: bound)
                let value = qr[keyPath: keyPath]
                let match = value == indexOfSelectedElement % bound
                modulus här blir fel för ROW, men funkar för column, men lösningen nedan med QR och keypath blir också fel. Något saknas?
//                let qrSelected = indexOfSelectedElement.quotientAndRemainder(dividingBy: bound)
//                let expected = qrSelected[keyPath: keyPath]
//                let match = value == expected
                guard match else { return nil }
                return offset
            })

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

internal extension Board {
    
    /// The number of region collections vertically stacked on the board.
    static let numberOfRegionsStackedVerticallyOnBoard = 3
    
    /// The number of region collections horizontally aligned on the board.
    static let numberOfRegionsStackedHorizontallyOnBoard = 3
    
    func column(of cell: Cell) -> Column {
        
        let regionIndex = cell.regionIndex
        let columnOfRegions: [Region] = regions.column(
            indexOfSelectedElement: regionIndex,
            boundedBy: Self.numberOfRegionsStackedHorizontallyOnBoard
        )
        
        
        let cells = columnOfRegions
            .flatMap({ (region) -> [Cell] in
                return region.cellsInSameColumnAs(columnIndex: cell.columnIndexWithinRegion)
            })
        
        let columnIndex = cell.globalColumnIndex
        
        return Column(index: columnIndex, cells: cells)
    }
    
    func row(of cell: Cell) -> Row {
        
        let regionIndex = cell.regionIndex
        let rowIndex = cell.globalRowIndex

        let rowOfRegions: [Region] = regions.row(
            indexOfSelectedElement: regionIndex,
            boundedBy: Self.numberOfRegionsStackedVerticallyOnBoard
        )
        
        print("rowOfRegions: \(rowOfRegions)")
        
        let cells = rowOfRegions
            .flatMap({ (region) -> [Cell] in
                return region.cellsInSameRowAs(rowIndex: cell.rowIndexWithinRegion)
            })
        
        
        return Row(index: rowIndex, cells: cells)
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
