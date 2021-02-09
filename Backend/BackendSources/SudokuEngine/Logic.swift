//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-02-09.
//

import Foundation

@discardableResult
func checkForDuplicateDigits(
    in cells: [Cell],
    scope: Scope
) throws -> [Cell] {
    let digits = cells.compactMap { $0.fill.digit }
    let uniqueDigits = Set(digits)
    guard uniqueDigits.count == digits.count else {
        throw SudukoError.digitAlready(in: scope)
    }
    return cells
}
