
public func todo(
    _ message: String,
    _ function: String = #function,
    _ line: Int = #line,
    _ file: String = #file
) {
    print("\(function) \(message) (line: \(line) in file: '\(file)'")
}

public struct Game {
    
    public private(set) var board: Board
    public private(set) var numberOfFills: UInt = 0
    
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
        numberOfFills += 1
        todo("Implement game logic here")
        // TODO: Implement game logic here
    }
}
