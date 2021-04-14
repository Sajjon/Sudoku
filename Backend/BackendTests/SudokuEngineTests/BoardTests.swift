import XCTest
@testable import SudokuEngine

final class BoardTests: XCTestCase {
        
    func testRegionViewGlobalIndexIsIncrementedWithinRegionFirst() {
        let board = Board.empty
        let globalIndices: [Int] = board.regions.flatMap({ $0.cells.map({ $0.globalIndex }) })
        func doTest(windowOfSize2: Array<Int>.SubSequence) {
            let globalIndices = Array(windowOfSize2)
            XCTAssertEqual(globalIndices.count, 2)
            let first = globalIndices[0]
            let second = globalIndices[1]
            XCTAssertEqual(second - first, 1)
        }
        globalIndices.windows(ofCount: 2).forEach(doTest)
    }
    
    func testThatEveryRegionConsistsOf9Cells() {
        let board = Board.empty
        func doTest(region: Region) {
            XCTAssertEqual(region.cells.count, 9)
        }
        board.regions.forEach(doTest)
    }
    
    func testThatABoardConsistsOf9Regions() {
        let board = Board.empty
        XCTAssertEqual(board.regions.count, 9)
    }
    
    func testThatABoardConsistsOf81Cells() {
        let board = Board.empty
        XCTAssertEqual(
            board.regions.map({ $0.cells.count }).reduce(0, +),
            81
        )
    }
}
