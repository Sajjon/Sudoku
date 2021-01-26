//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-01-17.
//

import Foundation

private extension Int {
    static let sudokuSquareCount = 81
}

public struct Board {
    
    public private(set) var squares: [Square]
    
    public init(squares: [Square]) {
        precondition(squares.count == .sudokuSquareCount)
        self.squares = squares
    }
    
    public init(squareFills: [Fill]) {
        precondition(squareFills.count == .sudokuSquareCount)
        self.init(squares: squareFills.enumerated().map({ index, fill in
            Square(globalIndex: index, fill: fill)
        }))
    }
    
}

internal extension Board {
  
    
    mutating func fill(
        square: Square,
        with fill: Fill
    ) {

        squares[square.globalIndex] = .init(globalIndex: square.globalIndex, fill: fill)
    }
}


public extension Board {
    
    static func allSquaresFilled(with fill: Fill) -> Self {
        .init(squareFills: .init(repeating: fill, count: .sudokuSquareCount))
    }
    
    static let empty: Self = .allSquaresFilled(with: .empty)
    
    static let example = Self(squareFills: [
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
