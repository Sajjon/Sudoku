
public func todo(_ message: String) {
    print("\(#function) \(message) (line: \(#line) in file: \(#file)")
}

public struct Game {
    
    public private(set) var board: Board
    
    public init(board: Board) {
        self.board = board
    }
}

public extension Game {
    
    mutating func fill(
        square: Square,
        with fill: Fill
    ) {
        board.fill(square: square, with: fill)
    }
}
