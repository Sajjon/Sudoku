//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-01-17.
//

import Foundation

public struct Square: Equatable {
    public let globalIndex: Index
    public let fill: Fill
}

public extension Square {
    typealias Index = Int
}
