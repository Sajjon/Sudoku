import XCTest
@testable import SudokuEngine

// STOLEN FROM: https://stackoverflow.com/a/39891965/1311272
extension Collection where Self.Iterator.Element: RandomAccessCollection {
    // PRECONDITION: `self` must be rectangular, i.e. every row has equal size.
    func transposed() -> [[Self.Iterator.Element.Iterator.Element]] {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map{ $0[index] }
        }
    }
}

final class BoardTests: XCTestCase {
    
    func testRegionViewGlobalIndexIsIncrementedWithinRegionFirst() {
        let board = Board.empty
        
        assertThatCells(in: board, view: \.regions)
        
    }
    
//    func testRowViewGlobalIndexIsIncrementedWithinRowFirst() {
//        let board = Board.empty
//        assertThatCells(in: board, view: \.rows)
//    }
    
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
    
    func testGlobalIndicesOfRegionBasedRepresentation() {
        let board = Board.empty
        
        enum RegionIndex {
            case region(Int)
            var index: Int { switch self { case .region(let regionIndex): return regionIndex } }
        }
        
        func assertThatGlobalIndicesOfCells(
            in regionAtIndex: RegionIndex,
            at columnOrRow: ColumnOrRowIndex,
            equals expectedGlobalIndices: [Cell.Index]
        ) {
            let regionIndex = regionAtIndex.index
            let region = board.regions[regionIndex]
            let adjacentCells = columnOrRow.adjecentCells(in: region)
            let globalIndices = adjacentCells.map{ $0.globalIndex }
            XCTAssertEqual(globalIndices, expectedGlobalIndices)
            
        }
        
        func assertThatGlobalIndicesForEachRow(
            in regionAtIndex: RegionIndex,
            equals expectedGlobalIndicesPerRow: [[Cell.Index]]
        ) {
            expectedGlobalIndicesPerRow
                .enumerated()
                .forEach({ (rowIndex, expectedGlobalIndices) in
                    assertThatGlobalIndicesOfCells(
                        in: regionAtIndex,
                        at: .row(rowIndex),
                        equals: expectedGlobalIndices
                    )
                })
        }
        
        func assertThatGlobalIndicesForEachColumn(
            in regionAtIndex: RegionIndex,
            equals expectedGlobalIndicesPerColumn: [[Cell.Index]]
        ) {
            expectedGlobalIndicesPerColumn
                .enumerated()
                .forEach({ (columnIndex, expectedGlobalIndices) in
                    assertThatGlobalIndicesOfCells(
                        in: regionAtIndex,
                        at: .column(columnIndex),
                        equals: expectedGlobalIndices
                    )
                })
        }

        func assertThatGlobalIndicesForEachRowAndColumn(
            in region: RegionIndex,
            equals expectedGlobalIndicesForRow: [[Cell.Index]]
        ) {
            
            
            assertThatGlobalIndicesForEachRow(
                in: region,
                equals: expectedGlobalIndicesForRow
            )
            
            assertThatGlobalIndicesForEachColumn(
                in: region,
                equals: expectedGlobalIndicesForRow.transposed()
            )
        }
        
        assertThatGlobalIndicesForEachRowAndColumn(
            in: .region(0),
            equals: [
                [0, 1, 2],
                [3, 4, 5],
                [6, 7, 8]
            ]
        )
        
        assertThatGlobalIndicesForEachRowAndColumn(
            in: .region(1),
            equals: [
                [9, 10, 11],
                [12, 13, 14],
                [15, 16, 17]
            ]
        )
        
        assertThatGlobalIndicesForEachRowAndColumn(
            in: .region(2),
            equals: [
                [18, 19, 20],
                [21, 22, 23],
                [24, 25, 26]
            ]
        )
     
        assertThatGlobalIndicesForEachRowAndColumn(
            in: .region(3),
            equals: [
                [27, 28, 29],
                [30, 31, 32],
                [33, 34, 35]
            ]
        )
        
        assertThatGlobalIndicesForEachRowAndColumn(
            in: .region(8),
            equals: [
                [72, 73, 74],
                [75, 76, 77],
                [78, 79, 80]
            ]
        )

    }
    func testTranspose() {
        let matrix = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8]
        ]
        
        
        XCTAssertEqual(
            matrix.transposed(),
            [
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8]
        ]
        )
    }
    
    func testApa() throws {
        let board = Board.empty
        let c15 = try XCTUnwrap(board.regions[1].cells.first(where: { $0.globalIndex == 15 }))
        XCTAssertEqual(c15.globalIndex, 15)
        let c15Column = board.column(of: c15)
        XCTAssertEqual(c15Column.index, 3)
        // Fortsätt här
        XCTAssertEqual(c15Column.cells.count, 9)
        XCTAssertTrue(c15Column.cells.allSatisfy({ $0.globalColumnIndex == 3 }))
        XCTAssertEqual(c15Column.cells.map({ $0.globalColumnIndex }), [9, 12, 15, 36, 39, 42, 63, 66, 69])
        
    }
}


private extension BoardTests {
    
    func assertThatCells<View>(
        in board: Board,
        view viewKeyPath: KeyPath<Board, View>
    ) where View: Collection, View.Element: CellCollection {
        let view: View = board[keyPath: viewKeyPath]
        let cellMatrix: [[Cell]] = view.map { $0.cells }
        return assertThatIndexOfCellsAreStrictlyIncrementedByOne(cellMatrix: cellMatrix)
    }
    
    func assertThatIndexOfCellsAreStrictlyIncrementedByOne(cellMatrix: [[Cell]]) {
        let globalIndices: [Int] = cellMatrix.flatMap({ $0.map({ $0.globalIndex }) })
        XCTAssertEqual(globalIndices.count, 81)
        func doTest(windowOfSize2: Array<Int>.SubSequence) {
            let globalIndices = Array(windowOfSize2)
            XCTAssertEqual(globalIndices.count, 2)
            let first = globalIndices[0]
            let second = globalIndices[1]
            XCTAssertEqual(second - first, 1)
        }
        globalIndices.windows(ofCount: 2).forEach(doTest)
    }
}
