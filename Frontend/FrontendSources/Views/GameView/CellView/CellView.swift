//
//  CellView.swift
//  FrontendSources
//
//  Created by Alexander Cyon on 2021-01-17.
//

import SwiftUI
import SudokuEngine

struct CellView: View {
    let cell: Cell
    @Binding var isSelected: Bool
    
    var body: some View {
        ZStack {
            
        Rectangle()
            .fill(Color.white)
            .aspectRatio(1, contentMode: .fill)
            .border(
                isSelected ? Color.red : .orange,
                width: isSelected ? 2 : 1
            )
            
            Text("\(cell.globalIndex)")
//            Text("\(cell.fill.description)")
        }
    }
    
}
