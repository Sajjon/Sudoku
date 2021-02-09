//
//  GameView.swift
//  FrontendSources
//
//  Created by Alexander Cyon on 2021-01-17.
//

import SwiftUI
import SudokuEngine

extension Binding {
    static func readonly(_ get: @escaping @autoclosure () -> Value) -> Self {
        return Self(
            get: get,
            set: { _ in fatalError() }
        )
    }
}

struct GameView: View {
    
    @ObservedObject var viewModel: ViewModel
    let finishedGame: () -> Void
    
}

extension GameView {
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Number of fills: \(viewModel.numberOfFills)")
            boardView
            pickNumberView
            Spacer()
            GradientButton("End Game", action: finishedGame)
        }
        .padding()
    }
}

private extension GameView {
    var boardView: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.adaptive(minimum: 50), spacing: 10), count: 9),
            spacing: 5
        ) {
            ForEach(viewModel.allCells) { cell in
                VStack {
                    
                    HStack {
                        CellView(
                            cell: cell,
                            isSelected: .readonly(viewModel.idOfSelectedCell == cell.id)
                        )
                        .onTapGesture {
                            if viewModel.idOfSelectedCell == cell.id {
                                viewModel.idOfSelectedCell = nil
                            } else {
                                viewModel.idOfSelectedCell = cell.id
                            }
                        }
                        
                        let indexOffsetted = cell.globalIndex + 1
                        if indexOffsetted.isMultiple(of: 3) && !indexOffsetted.isMultiple(of: 9) {
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 2)
                        }
                    }
                    
                    
                    if
                        (cell.globalIndex >= 18 && cell.globalIndex < 27) ||
                            (cell.globalIndex >= 45 && cell.globalIndex < 54)
                    {
                        Rectangle()
                            .fill(Color.black)
                            .frame(height: 2)
                    }
                }
            }
        }
    }
    
    var pickNumberView: some View {
        HStack {
            ForEach(Fill.allCases) { fill in
                Button {
                    viewModel.userDidSelectFill(fill)
                } label: {
                    Text("\(fill.value)")
                        .font(Font.title)
                        .frame(minWidth: 30, minHeight: 30)
                        .foregroundColor(.white)
                        .background(viewModel.isAnyCellSelected ? Color.blue : Color.gray)
                        .clipShape(Circle())
                }
            }
            .disabled(!viewModel.isAnyCellSelected)
            .aspectRatio(1, contentMode: .fit)
        }
    }
}


extension Fill: Identifiable {}
public extension Fill {
    typealias ID = IntegerLiteralType
    var id: ID {
        value
    }
}
