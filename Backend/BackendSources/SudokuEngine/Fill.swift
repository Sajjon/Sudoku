//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-01-17.
//

import Foundation

public enum Fill: Equatable, CaseIterable, ExpressibleByIntegerLiteral, CustomStringConvertible {
    case filled(Digit)
    case empty
}

public extension Fill {
    
    var value: IntegerLiteralType {
        switch self {
        case .empty: return 0
        case .filled(let digit): return digit.rawValue
        }
    }
}

// MARK: ExpressibleByIntegerLiteral
public extension Fill {
    typealias IntegerLiteralType = Digit.IntegerLiteralType
    init(integerLiteral value: IntegerLiteralType) {
        if value == 0 {
            self = .empty
        } else if let digit = Digit(rawValue: value) {
            self = .filled(digit)
        } else {
            fatalError("Bad value: \(value)")
        }
    }
}

// MARK: CustomStringConvertible
public extension Fill {
    var description: String {
        switch self {
        case .filled(let fill):
            return .init(describing: fill)
        case .empty:
            return " "
        }
    }
}

// MARK: CaseIterable
public extension Fill {
    typealias AllCases = [Self]
    static var allCases: [Fill] {
        let filledCases: [Fill] = Digit.allCases.map { Self.filled($0) }
        return [Self.empty] + filledCases
    }
}
