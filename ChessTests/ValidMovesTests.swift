//
//  ValidMoves.swift
//  ChessTests
//
//  Created by david crooks on 15/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import XCTest
@testable import Chess

class ValidMoves: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testNumberOfValidOpeningMovesForWhite() {
        let board = Chessboard.start()
        
        let moves = validMoves(chessboard: board)
        
        XCTAssert(moves.count == 20, "There should be 20 (16 pawns, 4 knights) valid first moves, found \(moves.count)")
        
        let pawnMoves = moves.filter{board[$0.from]?.kind == .pawn}
        
        XCTAssert(pawnMoves.count == 16, "There should be 16  valid first pawn moves, found \(pawnMoves.count)")
        
        let knightMoves = moves.filter{board[$0.from]?.kind == .knight}
        
        XCTAssert(knightMoves.count == 4, "There should be 4 valid first knight moves, found \(knightMoves.count)")
        
        XCTAssert(moves.allSatisfy{ board[$0.from]?.player == .white}, "All opening moves should be white pieces")
            
    }
    
    func testNumberOfValidOpeningMovesForBlack() {
        //white moves a pawn
        var board = apply( move: ChessMove(from: ChessboardSquare(rank: ._2, file: .e), to: ChessboardSquare(rank: ._3, file: .e)), to: Chessboard.start())
        
        let moves = validMoves(chessboard: board)
        
        XCTAssert(moves.count == 20, "There should be 20 (16 pawns, 4 knights) valid first moves, found \(moves.count)")
        
        let pawnMoves = moves.filter{board[$0.from]?.kind == .pawn}
        
        XCTAssert(pawnMoves.count == 16, "There should be 16  valid first pawn moves, found \(pawnMoves.count)")
        
        let knightMoves = moves.filter{board[$0.from]?.kind == .knight}
        
        XCTAssert(knightMoves.count == 4, "There should be 4 valid first knight moves, found \(knightMoves.count)")
        
        XCTAssert(moves.allSatisfy{ board[$0.from]?.player == .black}, "All moves after white has moved should be black pieces")
            
    }
    
    func testValidateSimpleMoves() {
        
        //A valid sequence of simple moves for a game
        let moves:[ChessMove] = [
                                    ChessMove(code:"e2->e4")!,
                                    ChessMove(code:"e7->e6")!,
                                    ChessMove(code:"f1->c4")!,
                                    ChessMove(code:"h7->h6")!,
                                    ChessMove(code:"d1->f3")!,
                                    ChessMove(code:"f8->a3")!,
                                    ChessMove(code:"b2->b3")!,
                                    ChessMove(code:"a3->c1")!,
                                    ChessMove(code:"b1->c3")!,
                                    ChessMove(code:"c1->d2")!,
                                    ChessMove(code:"e1->d2")!,
                                    ChessMove(code:"h8->h7")!,
                                    ChessMove(code:"a1->d1")!,
                                    ChessMove(code:"h7->h8")!,
                                    ChessMove(code:"g1->h3")!,
                                    ChessMove(code:"e6->e5")!,
                                    ChessMove(code:"h1->e1")!,
                                    ChessMove(code:"g7->g6")!
                                ]
        
        var  board = Chessboard.start()
        for move in moves {
            XCTAssert(isValid(move:move, on:board ), "move \(move) should be valid")
            board = apply(move: move, to: board)
        }
        
        
        XCTAssertFalse( isValid(move:ChessMove(code:"c4->c5")!, on:board ), "bishop cannot move up the file")
        XCTAssertFalse( isValid(move:ChessMove(code:"c3->d3")!, on:board ), "knight cannot move one sideways")
        XCTAssertFalse( isValid(move:ChessMove(code:"b3->b2")!, on:board ), "pawn cannot move backwards")
        
    }
    
    func testPerformanceValidMoves() {
        let moves:[ChessMove] = [
                                    ChessMove(code:"e2->e4")!,
                                    ChessMove(code:"e7->e6")!,
                                    ChessMove(code:"f1->c4")!,
                                    ChessMove(code:"h7->h6")!,
                                    ChessMove(code:"d1->f3")!,
                                    ChessMove(code:"f8->a3")!,
                                    ChessMove(code:"b2->b3")!,
                                    ChessMove(code:"a3->c1")!,
                                    ChessMove(code:"b1->c3")!,
                                    ChessMove(code:"c1->d2")!,
                                    ChessMove(code:"e1->d2")!,
                                    ChessMove(code:"h8->h7")!,
                                    ChessMove(code:"a1->d1")!,
                                    ChessMove(code:"h7->h8")!,
                                    ChessMove(code:"g1->h3")!,
                                    ChessMove(code:"e6->e5")!,
                                    ChessMove(code:"h1->e1")!,
                                    ChessMove(code:"g7->g6")!
                                ]
        
        var  board = Chessboard.start()
        
        for move in moves {
            board = apply(move: move, to: board)
        }
        
        self.measure {
            let _ = validMoves(chessboard: board)
        }
        
       
    }
    
    
func testPerformanceUncheckedValidMoves() {
        let moves:[ChessMove] = [
                                    ChessMove(code:"e2->e4")!,
                                    ChessMove(code:"e7->e6")!,
                                    ChessMove(code:"f1->c4")!,
                                    ChessMove(code:"h7->h6")!,
                                    ChessMove(code:"d1->f3")!,
                                    ChessMove(code:"f8->a3")!,
                                    ChessMove(code:"b2->b3")!,
                                    ChessMove(code:"a3->c1")!,
                                    ChessMove(code:"b1->c3")!,
                                    ChessMove(code:"c1->d2")!,
                                    ChessMove(code:"e1->d2")!,
                                    ChessMove(code:"h8->h7")!,
                                    ChessMove(code:"a1->d1")!,
                                    ChessMove(code:"h7->h8")!,
                                    ChessMove(code:"g1->h3")!,
                                    ChessMove(code:"e6->e5")!,
                                    ChessMove(code:"h1->e1")!,
                                    ChessMove(code:"g7->g6")!
                                ]
        
        var  board = Chessboard.start()
        
        for move in moves {
            board = apply(move: move, to: board)
        }
        
      
        
        self.measure {
            let _ = uncheckedValidMoves(chessboard: board)
        }
    }

}
