//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-02-09.
//

import Foundation

public enum Scope: CustomStringConvertible {
    case column(Int), row(Int), region(Int)
}

public extension Scope {
    var description: String {
        switch self {
        case .column(let columnIndex):
            return "column: \(columnIndex)"
        case .row(let rowIndex):
            return "row: \(rowIndex)"
        case .region(let regionIndex):
            return "region: \(regionIndex)"
            
        }
    }
}

extension RawRepresentable where RawValue == String, Self: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}
