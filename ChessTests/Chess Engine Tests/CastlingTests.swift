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
        
        let whiteCanCastleString = """

                                ♜  .  ♝  ♛  ♚  ♝  .  ♜
                                ♟  ♟  ♟  ♟  .  ♟  ♟  ♟
                                .  .  ♞  .  .  ♞  .  .
                                .  ♗  .  .  ♟  .  .  .
                                .  .  .  .  ♙  .  .  .
                                .  .  .  .  .  ♘  .  .
                                ♙  ♙  ♙  ♙  .  ♙  ♙  ♙
                                ♖  ♘  ♗  ♕  ♔  .  .  ♖

                                """
        let board =  Chessboard(string: whiteCanCastleString)!
        
        let move = ChessMove(player: .white,castleingSide: .kingside)
        
        XCTAssert(isValid(move: move, on: board))
        
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
