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
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            boardView
            pickNumberView
            Spacer()
            HStack(alignment: .center) {
                Spacer()
                GradientButton("End Game", action: finishedGame)
                Spacer()
                
            }
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
            ForEach(viewModel.allSquares) { square in
                VStack {
                    
                    HStack {
                        SquareView(
                            square: square,
                            isSelected: .readonly(viewModel.idOfSelectedSquare == square.id)
                        )
                        .onTapGesture {
                            if viewModel.idOfSelectedSquare == square.id {
                                viewModel.idOfSelectedSquare = nil
                            } else {
                                viewModel.idOfSelectedSquare = square.id
                            }
                        }
                        
                        let indexOffsetted = square.globalIndex + 1
                        if indexOffsetted.isMultiple(of: 3) && !indexOffsetted.isMultiple(of: 9) {
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 2)
                        }
                    }
                    
                    
                    if
                        (square.globalIndex >= 18 && square.globalIndex < 27) ||
                            (square.globalIndex >= 45 && square.globalIndex < 54)
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
                        .background(viewModel.isAnySquareSelected ? Color.blue : Color.gray)
                        .clipShape(Circle())
                }
            }
            .disabled(!viewModel.isAnySquareSelected)
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
