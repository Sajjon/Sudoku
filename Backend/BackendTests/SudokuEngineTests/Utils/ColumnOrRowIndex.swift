//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-06-02.
//

import Foundation
@testable import SudokuEngine

enum ColumnOrRowIndex: Equatable {
    case column(Int), row(Int)
}

extension ColumnOrRowIndex {
    var index: Int {
        switch self {
        case .column(let columnIndex):
            return columnIndex
        case .row(let rowIndex):
            return rowIndex
        }
    }
    
    var isRow: Bool {
        switch self {
        case .column:
            return false
        case .row:
            return true
        }
    }
    
    func adjecentCells(in region: Region) -> [Cell] {

        let getAdjecentCells: (Cell.Index) -> [Cell] = isRow ? region.cellsInSameRowAs(rowIndex:) : region.cellsInSameColumnAs(columnIndex:)

        return getAdjecentCells(index)
    }
}
