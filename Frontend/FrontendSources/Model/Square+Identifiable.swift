//
//  Cell+Identifiable.swift
//  FrontendSources
//
//  Created by Alexander Cyon on 2021-01-17.
//

import Foundation
import SudokuEngine

extension Cell: Identifiable {}
public extension Cell {
    typealias ID = Index
    var id: ID { globalIndex }
}
