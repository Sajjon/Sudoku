//
//  ThreeByThree.swift
//  FrontendSources
//
//  Created by Alexander Cyon on 2021-02-16.
//

import SwiftUI

struct ThreeByThree<CellElement, CellViewType>: View where CellElement: Identifiable, CellViewType: View {
    private let elements: [CellElement]
    private let gridItem: GridItem
    private let cellContent: (CellElement) -> CellViewType
    private let spaceBetweenRows: CGFloat
    init(
        _ elements: [CellElement],
        spaceBetweenRows: CGFloat,
        gridItem: GridItem,
        @ViewBuilder cellContent: @escaping (CellElement) -> CellViewType
    ) {
        self.elements = elements
        self.spaceBetweenRows = spaceBetweenRows
        self.gridItem = gridItem
        self.cellContent = cellContent
    }
}

extension ThreeByThree {
    var body: some View {
        LazyVGrid(
            columns: Array(repeating: gridItem, count: 3),
            spacing: spaceBetweenRows
        ) {
            ForEach(elements, content: cellContent)
        }
    }
}
