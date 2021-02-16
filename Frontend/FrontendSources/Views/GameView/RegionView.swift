//
//  RegionView.swift
//  FrontendSources
//
//  Created by Alexander Cyon on 2021-02-16.
//

import SwiftUI
import SudokuEngine

typealias RegionView = ThreeByThree<Cell, AnyView>

extension RegionView {
    private static let spacing: CGFloat = 0
    init(
        region: Region,
        gridItem: GridItem = .init(.adaptive(minimum: 40), spacing: Self.spacing),
        toggleCellSelected: Binding<Cell.ID?>
    ) {
        self.init(
            region.cells,
            spaceBetweenRows: Self.spacing,
            gridItem: gridItem
        ) { cell in
            CellView(
                cell: cell,
                isSelected: .readonly(cell.id == toggleCellSelected.projectedValue.wrappedValue)
            )
            .onTapGesture {
                if toggleCellSelected.projectedValue.wrappedValue == cell.id {
                    toggleCellSelected.projectedValue.wrappedValue = nil
                } else {
                    toggleCellSelected.projectedValue.wrappedValue = cell.id
                }
            }.eraseToAnyView()
        }
    }
}
