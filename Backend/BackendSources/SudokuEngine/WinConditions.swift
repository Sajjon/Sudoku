//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2021-01-26.
//

import Foundation


struct WinCon {
    var fields:[[Int]]
    var correct:[[Result]]
    
enum Result {
    case correct
    case incorrect
    case notset
}

    init() {
        self.fields = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        self.correct = Array(repeating: Array(repeating: .notset, count: 9), count: 9)
    }
    
    

}



//
public struct Grid {
    let fullGrid = Square(Fill.filled, fill: .filled(Digit))
    public enum Rows: Int,
    {
        case one = 1
        case two, three, four, five, six, seven, eight, nine
    }
    enum 
}


public struct winTest {
    
    enum Columns: UInt, Equateable, CaseIterable, ExpressibleByIntegerLiteral,
                  CustomStringConvertible {
        typealias IntegerLiteralType = RawValue
        
        case column1 = Board.squareFills[0]
        case column2, column3, column4, column5, column6, column7, column8, column9
        
        func testColumns(_ Columns: Int) -> Bool {
            for column in Columns {
                if column != Columns[0...8] {
                    continue
                } else {
                    return False
                }
                
            }
        }
    }
}
