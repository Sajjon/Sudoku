
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
        cell: Cell,
        with fill: Fill
    ) throws {
        try board.fill(cell: cell, with: fill)
        numberOfFills += 1
    }
}
