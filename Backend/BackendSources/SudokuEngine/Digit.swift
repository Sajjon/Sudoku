//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-01-17.
//

import Foundation


public enum Digit: UInt8,
    Equatable,
    CaseIterable,
    ExpressibleByIntegerLiteral,
    CustomStringConvertible
{
    case one = 1
    case two, three, four, five, six, seven, eight, nine
}


// MARK: ExpressibleByIntegerLiteral
public extension Digit {
    typealias IntegerLiteralType = RawValue
    init(integerLiteral value: IntegerLiteralType) {
        guard let digit = Self.init(rawValue: value) else {
            fatalError("Bad interger literal value: \(value)")
        }
        self = digit
    }
}

// MARK: CustomStringConvertible
public extension Digit {
    var description: String {
        "\(rawValue)"
    }
}

// MARK: CaseIterable
public extension Digit {
    typealias AllCases = [Self]
    static var allCases: [Digit] = [.one, .two, three, .four, .five, .six, .seven, .eight, .nine]
}
