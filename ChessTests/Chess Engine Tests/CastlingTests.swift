//
//  CastlingTests.swift
//  ChessTests
//
//  Created by David Crooks on 11/01/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import XCTest
@testable import Dark_Chess


class CastlingTests: XCTestCase {

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
    
    func  testCastleMove() {
        
        let castleString = """

                            ♜  .  .  .  ♚  .  .  ♜
                            ♟  ♟  ♟  .  .  ♟  ♟  ♟
                            .  .  .  .  .  .  .  .
                            .  .  .  .  .  .  .  .
                            .  .  .  .  .  .  .  .
                            .  .  .  .  .  .  .  .
                            ♙  ♙  ♙  .  .  ♙  ♙  ♙
                            ♖  .  .  .  ♔  .  .  ♖

                            """
        
        let whiteKingside = ChessMove(player: .white, castleingSide: .kingside)
        let whiteQueenside = ChessMove(player: .white, castleingSide: .queenside)
        let blackQueenside = ChessMove(player: .black, castleingSide: .queenside)
        let blackKingside = ChessMove(player: .black, castleingSide: .kingside)
        
        var board = Chessboard(string: castleString)!
        
        board = apply(move: whiteKingside, to: board)
        board = apply(move: blackKingside, to: board)
        
        
        let expectedKingsideString = """

                            ♜  .  .  .  .  ♜  ♚  .
                            ♟  ♟  ♟  .  .  ♟  ♟  ♟
                            .  .  .  .  .  .  .  .
                            .  .  .  .  .  .  .  .
                            .  .  .  .  .  .  .  .
                            .  .  .  .  .  .  .  .
                            ♙  ♙  ♙  .  .  ♙  ♙  ♙
                            ♖  .  .  .  .  ♖  ♔  .

                            """
        
        let expectedKingsideBoard = Chessboard(string:expectedKingsideString)!
        
        XCTAssert(expectedKingsideBoard.same(as: board))
        
       //start again
       board = Chessboard(string: castleString)!
       
       board = apply(move: whiteQueenside, to: board)
       board = apply(move: blackQueenside, to: board)
       
       
       let expectedQueensideString = """

                           .  .  ♚  ♜  .  .  .  ♜
                           ♟  ♟  ♟  .  .  ♟  ♟  ♟
                           .  .  .  .  .  .  .  .
                           .  .  .  .  .  .  .  .
                           .  .  .  .  .  .  .  .
                           .  .  .  .  .  .  .  .
                           ♙  ♙  ♙  .  .  ♙  ♙  ♙
                           .  .  ♔  ♖  .  .  .  ♖

                           """
       
       let expectedQueensideBoard = Chessboard(string: expectedQueensideString)!
       
       XCTAssert(expectedQueensideBoard.same(as: board))
        
    }
    
    

    func testCanCastleKingsideWhenValid() {
        
        let canCastleString = """

                                ♜  .  ♝  ♛  ♚  .  .  ♜
                                ♟  ♟  ♟  ♟  ♝  ♟  ♟  ♟
                                .  .  ♞  .  .  ♞  .  .
                                .  ♗  .  .  ♟  .  .  .
                                .  .  .  .  ♙  .  .  .
                                .  .  .  .  .  ♘  .  .
                                ♙  ♙  ♙  ♙  .  ♙  ♙  ♙
                                ♖  ♘  ♗  ♕  ♔  .  .  ♖

                                """
        var board =  Chessboard(string: canCastleString)!
        
        let whitemove = ChessMove(player: .white,castleingSide: .kingside)
        let blackmove = ChessMove(player: .black,castleingSide: .kingside)
        
        XCTAssert(isValid(move: whitemove, on: board))
        
        board = apply(move: whitemove, to: board)
        
        XCTAssert(isValid(move: blackmove, on: board))
        
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testCannotCastleIfOppenentControlsSpace() {
        let bishopControls = """

                                    ♜  .  .  ♛  ♚  ♝  .  ♜
                                    ♟  .  ♟  ♟  .  ♟  ♟  ♟
                                    ♝  .  ♟  .  .  ♞  .  .
                                    .  .  .  .  ♟  .  .  .
                                    .  .  .  .  ♙  .  .  .
                                    .  .  ♘  .  .  ♘  .  .
                                    ♙  ♙  ♙  ♙  .  ♙  ♙  ♙
                                    ♖  ♘  ♗  ♕  ♔  .  .  ♖

                                    """
        
        
        let board =  Chessboard(string: bishopControls )!
               
        let move = ChessMove(player: .white, castleingSide: .kingside)
        
        XCTAssertFalse(isValid(move: move, on: board),"Cannont castle when an oppent controls the space between the king and rook")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testCannotCastleIfAlreadyMoved() {
        let canCastleString = """

                                ♜  .  ♝  ♛  ♚  .  .  ♜
                                ♟  ♟  ♟  ♟  ♝  ♟  ♟  ♟
                                .  .  ♞  .  .  ♞  .  .
                                .  ♗  .  .  ♟  .  .  .
                                .  .  .  .  ♙  .  .  .
                                .  .  .  .  .  ♘  .  .
                                ♙  ♙  ♙  ♙  .  ♙  ♙  ♙
                                ♖  ♘  ♗  ♕  ♔  .  .  ♖

                                """
        let initialBoard =                 Chessboard(string: canCastleString)!
        var board =                 Chessboard(string: canCastleString)!
        
        let whiteMovesKing =        ChessMove(code: "e1->e2")!
        let blackMovesRook =        ChessMove(code: "h8-g8")!
        let whiteMovesKingBack =    ChessMove(code: "e2->e1")!
        let blackMovesRookBack =    ChessMove(code: "g8->h8")!
        
        
        board = apply(move: whiteMovesKing, to: board)
        board = apply(move: blackMovesRook, to: board)
        board = apply(move: whiteMovesKingBack, to: board)
        board = apply(move: blackMovesRookBack, to: board)
        
        XCTAssert(board.same(as: initialBoard),"All the pieces should be back where they where")
        
        let whitecastles = ChessMove(player: .white,castleingSide: .kingside)
        let blackcastles = ChessMove(player: .black,castleingSide: .kingside)
        
        //the board looks the same but niether side can castle now:
        
        XCTAssertFalse(isValid(move: whitecastles, on: board),"Cannot castle after moveing king")
        
        board = apply(move:whiteMovesKing, to: board)
        
        XCTAssertFalse(isValid(move:blackcastles, on: board),"Cannot castle after moveing rook")
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
