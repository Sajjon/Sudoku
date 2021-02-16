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
        BoardView(
            viewModel.regions,
            spaceBetweenRows: 10,
            gridItem: GridItem(.flexible(minimum: 100), spacing: 10)
        ) { region in
            RegionView(
                region: region,
                toggleCellSelected: $viewModel.idOfSelectedCell
            )
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
