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

extension Board {
    /// O(n) 😱 but hey, we don't expect THAT big a board...
    func findCell(
        withGlobalIndex targetCellGlobalIndex: Int
    ) -> Cell? {
        let allCells = regions.flatMap({ $0.cells })
        return allCells.first(where: { $0.globalIndex == targetCellGlobalIndex })
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
            equals expectedGlobalIndices: [Cell.Index],
            _ line: UInt = #line
        ) {
            let regionIndex = regionAtIndex.index
            let region = board.regions[regionIndex]
            let adjacentCells = columnOrRow.adjecentCells(in: region)
            let globalIndices = adjacentCells.map{ $0.globalIndex }
            XCTAssertEqual(globalIndices, expectedGlobalIndices, line: line)
            
        }
        
        func assertThatGlobalIndicesForEachRow(
            in regionAtIndex: RegionIndex,
            equals expectedGlobalIndicesPerRow: [[Cell.Index]],
            _ line: UInt = #line
        ) {
            expectedGlobalIndicesPerRow
                .enumerated()
                .forEach({ (rowIndex, expectedGlobalIndices) in
                    assertThatGlobalIndicesOfCells(
                        in: regionAtIndex,
                        at: .row(rowIndex),
                        equals: expectedGlobalIndices,
                        line
                    )
                })
        }
        
        func assertThatGlobalIndicesForEachColumn(
            in regionAtIndex: RegionIndex,
            equals expectedGlobalIndicesPerColumn: [[Cell.Index]],
            _ line: UInt = #line
        ) {
            expectedGlobalIndicesPerColumn
                .enumerated()
                .forEach({ (columnIndex, expectedGlobalIndices) in
                    assertThatGlobalIndicesOfCells(
                        in: regionAtIndex,
                        at: .column(columnIndex),
                        equals: expectedGlobalIndices,
                        line
                    )
                })
        }
        
        func assertThatGlobalIndicesForEachRowAndColumn(
            in region: RegionIndex,
            equals expectedGlobalIndicesForRow: [[Cell.Index]],
            _ line: UInt = #line
        ) {
            
            
            assertThatGlobalIndicesForEachRow(
                in: region,
                equals: expectedGlobalIndicesForRow,
                line
            )
            
            assertThatGlobalIndicesForEachColumn(
                in: region,
                equals: expectedGlobalIndicesForRow.transposed(),
                line
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
    

    func test_get_all_other_cells_in_the_same_board_row_as_a_given_cell() throws {
        
        func doTest(
            targetCellGlobalIndex: Int,
            expectedRowIndex: Int,
            expectedCellIndicies: [Int]
        ) throws {
            
            let board = Board.empty
            // GIVEN a cell
            let targetCell = try XCTUnwrap(board.findCell(withGlobalIndex: targetCellGlobalIndex))
            XCTAssertEqual(targetCell.globalIndex, targetCellGlobalIndex)
            // WHEN we query cells in same column as that cell
            let rowOfTargetCell = board.row(of: targetCell)
            XCTAssertEqual(rowOfTargetCell.index, expectedRowIndex)
            XCTAssertEqual(rowOfTargetCell.cells.count, 9)
            TODO fortsatt har blir fel row
            XCTAssertEqual(rowOfTargetCell.cells.map({ $0.globalRowIndex }), [Int](repeating: expectedRowIndex, count: 9))
            // THEN we can assert their global indices.
            XCTAssertEqual(rowOfTargetCell.cells.map({ $0.globalIndex }), expectedCellIndicies)
            
        }
        
        try doTest(
            targetCellGlobalIndex: 0,
            expectedRowIndex: 0,
            expectedCellIndicies: [0, 1, 2, 9, 10, 11, 18, 19, 20]
        )
        try doTest(
            targetCellGlobalIndex: 60,
            expectedRowIndex: 8,
            expectedCellIndicies: [60, 61, 62, 69, 70, 71, 78, 79, 80]
        )
        try doTest(
            targetCellGlobalIndex: 42,
            expectedRowIndex: 5,
            expectedCellIndicies: [33, 34, 35, 42, 43, 44, 51, 52, 53]
        )
    }
    
    func test_get_all_other_cells_in_the_same_board_column_as_a_given_cell() throws {
        
        func doTest(
            targetCellGlobalIndex: Int,
            expectedColumnIndex: Int,
            expectedCellIndicies: [Int]
        ) throws {
            
            let board = Board.empty
            // GIVEN a cell
            let targetCell = try XCTUnwrap(board.findCell(withGlobalIndex: targetCellGlobalIndex))
            XCTAssertEqual(targetCell.globalIndex, targetCellGlobalIndex)
            // WHEN we query cells in same column as that cell
            let columnOfTargetCell = board.column(of: targetCell)
            XCTAssertEqual(columnOfTargetCell.index, expectedColumnIndex)
            XCTAssertEqual(columnOfTargetCell.cells.count, 9)
            XCTAssertTrue(columnOfTargetCell.cells.allSatisfy({ $0.globalColumnIndex == expectedColumnIndex }))
            // THEN we can assert their global indices.
            XCTAssertEqual(columnOfTargetCell.cells.map({ $0.globalIndex }), expectedCellIndicies)
            
            
        }
        try doTest(
            targetCellGlobalIndex: 15,
            expectedColumnIndex: 3,
            expectedCellIndicies: [9, 12, 15, 36, 39, 42, 63, 66, 69]
        )
        try doTest(
            targetCellGlobalIndex: 23,
            expectedColumnIndex: 8,
            expectedCellIndicies: [20, 23, 26, 47, 50, 53, 74, 77, 80]
        )
        try doTest(
            targetCellGlobalIndex: 62,
            expectedColumnIndex: 2,
            expectedCellIndicies: [2, 5, 8, 29, 32, 35, 56, 59, 62]
        )
        try doTest(
            targetCellGlobalIndex: 31,
            expectedColumnIndex: 1,
            expectedCellIndicies: [1, 4, 7, 28, 31, 34, 55, 58, 61]
        )
        try doTest(
            targetCellGlobalIndex: 80,
            expectedColumnIndex: 8,
            expectedCellIndicies: [20, 23, 26, 47, 50, 53, 74, 77, 80]
        )
        
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
