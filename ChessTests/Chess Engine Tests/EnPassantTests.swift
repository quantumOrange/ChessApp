//
//  EnPassantTests.swift
//  ChessTests
//
//  Created by David Crooks on 11/01/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import XCTest
@testable import Dark_Chess

class EnPassantTests: XCTestCase {

    override func setUp() {
        let chessString = """

        ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜
        ♟  ♟  ♟  ♟  ♟  ♟  ♟  ♟
        .  .  .  .  .  .  .  .
        .  .  .  .  .  .  .  .
        .  .  .  .  .  .  .  .
        .  .  .  .  .  .  .  .
        ♙  ♙  ♙  ♙  ♙  ♙  ♙  ♙
        ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖

        """
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCanTakeEnPassantWhenValid() {
        let chessString = """

                    ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜
                    ♟  ♟  ♟  ♟  ♟  ♟  .  ♟
                    .  .  .  .  .  .  .  .
                    .  .  ♙  .  .  .  ♟  .
                    .  .  .  .  .  .  .  .
                    .  .  .  .  .  .  .  .
                    ♙  ♙  .  ♙  ♙  ♙  ♙  ♙
                    ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖

                    """
        // black to move
        
        guard let startboard = Chessboard(string:chessString) else {
            XCTFail("Failed to load chessboard")
            return
        }
        
        let blackMovesPawnTwoSpaces =       ChessMove(code:"d7->d5")!
        let whiteTakesEnPassant     =       ChessMove(code:"c5->d6")!
        
        var chessboard = startboard
        
        chessboard = apply(move:blackMovesPawnTwoSpaces,    to: chessboard)
        
        XCTAssert(isValid(move:whiteTakesEnPassant, on:chessboard), "White shoub be able to take enpassant here")
        
        chessboard = apply(move:whiteTakesEnPassant,    to: chessboard)
        
        
        let expectedBoardString = """

                                    ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜
                                    ♟  ♟  ♟  .  ♟  ♟  .  ♟
                                    .  .  .  ♙  .  .  .  .
                                    .  .  .  .  .  .  ♟  .
                                    .  .  .  .  .  .  .  .
                                    .  .  .  .  .  .  .  .
                                    ♙  ♙  .  ♙  ♙  ♙  ♙  ♙
                                    ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖

                                    """
        
        let expectedBoard = Chessboard(string: expectedBoardString)
        
        
        XCTAssert(chessboard.same(as: expectedBoard!))
        
        
    }
    
    func testCannotTakeEnPassantUnlessJustMoved() {
        let chessString = """

                           ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜
                           ♟  ♟  ♟  ♟  ♟  ♟  .  ♟
                           .  .  .  .  .  .  .  .
                           .  .  ♙  .  .  .  ♟  .
                           .  .  .  .  .  .  .  .
                           .  .  .  .  .  .  .  .
                           ♙  ♙  .  ♙  ♙  ♙  ♙  ♙
                           ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖

                           """
       // black to move
           
       guard let startboard = Chessboard(string:chessString) else {
           XCTFail("Failed to load chessboard")
           return
       }
       
       let blackMovesPawnTwoSpaces  =    ChessMove(code:"d7->d5")!
       let irrelevantWhiteMove      =    ChessMove(code:"h2->h3")!
       let irrelevantBlackMove      =    ChessMove(code:"h7->h6")!
        
       let whiteTakesEnPassant      =    ChessMove(code:"c5->d6")!
       
       var chessboard = startboard
       
       chessboard = apply(move:blackMovesPawnTwoSpaces, to: chessboard)
       chessboard = apply(move:irrelevantWhiteMove,     to: chessboard)
       chessboard = apply(move:irrelevantBlackMove,     to: chessboard)
       
       XCTAssertFalse(isValid(move:whiteTakesEnPassant, on:chessboard), "White should not be able to take enpassant, as the black piece to take did not move last turn")
       
           
    }
    
    func testCannotTakeEnPassantWhenInvalid() {
        let chessString = """

                        ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜
                        ♟  ♟  ♟  .  ♟  ♟  .  ♟
                        .  .  .  .  .  .  .  .
                        .  .  .  ♟  .  .  ♟  .
                        .  .  ♙  .  .  .  .  .
                        .  ♙  .  .  .  .  .  .
                        ♙  .  .  ♙  ♙  ♙  ♙  ♙
                        ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖

                        """
        // black to move
        var chessboard = Chessboard(string:chessString)!
        
        let blackPawnMovesPastWhite = ChessMove(code: "d5->d4")!
        let whiteTriesToTakeInvalidEnPassant = ChessMove(code: "c4->d5")!
        
        chessboard = apply(move: blackPawnMovesPastWhite, to: chessboard)
        
        XCTAssertFalse(isValid(move:whiteTriesToTakeInvalidEnPassant, on:chessboard), "White Pawn should be able to take en passant here")
        
    }
    
    func testCannotMoveDiagonallyWhenNotTaking() {
        let chessString = """

                        ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜
                        ♟  ♟  ♟  ♟  ♟  ♟  .  ♟
                        .  .  .  .  .  .  .  .
                        .  .  .  .  .  .  ♟  .
                        .  .  ♙  .  .  .  .  .
                        .  .  .  .  .  .  .  .
                        ♙  ♙  .  ♙  ♙  ♙  ♙  ♙
                        ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖

                        """
        
        var chessboard = Chessboard(string:chessString)!
        
        let whiteMovesDiagonal = ChessMove(code: "c4->d5")!
        let blackMovesDiagonal = ChessMove(code: "g5->f4")!
        
        
        XCTAssertFalse(isValid(move:whiteMovesDiagonal, on:chessboard), "White Pawn should not be able to move diagonally except when taking en passant")
        
        //
        let whiteMovesForward = ChessMove(code: "c4->c5")!
        chessboard = apply(move: whiteMovesForward, to: chessboard)
        
        XCTAssertFalse(isValid(move:blackMovesDiagonal, on:chessboard), "Black Pawn should not be able to move diagonally except when taking en passant")
        
        
        
    }
    
    //TODO: Add tests whith role of white and black reversed!
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
