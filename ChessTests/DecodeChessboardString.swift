//
//  DecodeChessboardString.swift
//  ChessTests
//
//  Created by David Crooks on 07/01/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import XCTest
@testable import Dark_Chess

class DecodeChessboardString: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBoardToStringAndBack() {
        
        let chessboard = Chessboard.start()
        
        print(chessboard)
        
        let string = "\(chessboard)"
        
        let maybeBoard = Chessboard(string:string)
        
        XCTAssertNotNil(maybeBoard)
        guard let newBoard = maybeBoard else { return }
        
        print(newBoard)
        
        chessboard.logStorage()
        newBoard.logStorage()
        
        XCTAssert(chessboard.same(as: newBoard))
        
    }

    func testStringToBoardAndBack() {
        
        let chessString = """

                    ♜  .  ♝  ♛  ♚  ♝  ♞  ♜
                    ♟  ♟  ♟  ♟  .  ♟  ♟  ♟
                    .  .  ♞  .  .  .  .  .
                    .  .  .  .  ♟  .  .  .
                    .  .  .  .  ♙  .  .  .
                    .  .  .  .  .  ♘  .  .
                    ♙  ♙  ♙  ♙  .  ♙  ♙  ♙
                    ♖  ♘  ♗  ♕  ♔  ♗  .  ♖

                    """
                    
        let maybeBoard = Chessboard(string:chessString)
        
        XCTAssertNotNil(maybeBoard)
        guard let chessboard = maybeBoard else { return }
                
        let newString = "\(chessboard)"
        
        func pruned(_ string:String )  -> String
        {
            return string.filter { !$0.isNewline && !$0.isWhitespace }
        }
        
        XCTAssertEqual(pruned(chessString), pruned(newString))
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

