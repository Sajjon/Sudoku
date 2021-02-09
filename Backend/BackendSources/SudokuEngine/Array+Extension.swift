//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-02-09.
//

import Foundation

public extension Array {
    mutating func updateElement(
        at index: Index,
        _ updateElement: (inout Element) throws -> Void
    ) rethrows {
        var element = self[index]
        try updateElement(&element)
        self[index] = element
    }
}
