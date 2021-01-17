//
//  Square+Identifiable.swift
//  FrontendSources
//
//  Created by Alexander Cyon on 2021-01-17.
//

import Foundation
import SudokuEngine

extension Square: Identifiable {}
public extension Square {
    typealias ID = Index
    var id: ID { globalIndex }
}
