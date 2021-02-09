//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-02-09.
//

import Foundation

internal extension Int {
    static let sudokuCellCountPerRegion = 9
    static let sudokuRegionCount = 9
    static var sudokuCellCount: Self {
        sudokuRegionCount * sudokuCellCountPerRegion
    }
}
