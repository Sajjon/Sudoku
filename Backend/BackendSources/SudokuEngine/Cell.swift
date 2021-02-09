//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-01-17.
//

import Foundation

public struct Cell: Equatable {
    public let regionIndex: Region.Index
    public let indexWithinRegion: Index
    public private(set) var fill: Fill
    
    public init(
        regionIndex: Region.Index,
        indexWithinRegion: Index,
        fill: Fill
    ) {
        self.regionIndex = regionIndex
        self.indexWithinRegion = indexWithinRegion
        self.fill = fill
    }
    
//    public init(
//        globalIndex: Index,
//        fill: Fill
//    ) {
//        let regionIndex = globalIndex / .sudokuCellCountPerRegion
//        let indexWithinRegion = globalIndex % .sudokuCellCountPerRegion
//        self.init(
//            regionIndex: regionIndex,
//            indexWithinRegion: indexWithinRegion,
//            fill: fill
//        )
//    }
}

internal extension Cell {
    mutating func fill(with fill: Fill) {
        self.fill = fill
    }

}

public extension Cell {
    var globalIndex: Index {
        regionIndex * .sudokuCellCountPerRegion + indexWithinRegion
    }
    typealias Index = Int
}
