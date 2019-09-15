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
        
        XCTAssert(moves.count == 16, "There should be 16  valid first pawn moves, found \(pawnMoves.count)")
        
        let knightMoves = moves.filter{board[$0.from]?.kind == .knight}
        
        XCTAssert(knightMoves.count == 4, "There should be 4 valid first knight moves, found \(knightMoves.count)")
        
        XCTAssert(moves.allSatisfy{ board[$0.from]?.player == .white}, "All opening moves should be white pieces")
            
    }
    
    func testNumberOfValidOpeningMovesForBlack() {
        var board = Chessboard.start()
        //white moves a pawn
        applyMove(board: &board, move: ChessMove(from: ChessboardSquare(rank: ._2, file: .e), to: ChessboardSquare(rank: ._3, file: .e)))
        
        let moves = validMoves(chessboard: board)
        
        XCTAssert(moves.count == 20, "There should be 20 (16 pawns, 4 knights) valid first moves, found \(moves.count)")
        
        let pawnMoves = moves.filter{board[$0.from]?.kind == .pawn}
        
        XCTAssert(moves.count == 16, "There should be 16  valid first pawn moves, found \(pawnMoves.count)")
        
        let knightMoves = moves.filter{board[$0.from]?.kind == .knight}
        
        XCTAssert(knightMoves.count == 4, "There should be 4 valid first knight moves, found \(knightMoves.count)")
        
        XCTAssert(moves.allSatisfy{ board[$0.from]?.player == .black}, "All moves after white has moved should be black pieces")
            
    }
    
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
