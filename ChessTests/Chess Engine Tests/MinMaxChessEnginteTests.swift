//
//  MinMaxChessEnginteTests.swift
//  ChessTests
//
//  Created by David Crooks on 13/10/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import XCTest
@testable import Dark_Chess

class MinMaxChessEnginteTests: XCTestCase {

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

    func testPerformanceExample() {
        // This is an example of a performance test case.
        
        let moves:[ChessMove] = [
                                    ChessMove(code:"e2->e4")!,
                                    ChessMove(code:"e7->e6")!,
                                    
                                    ChessMove(code:"f1->c4")!,
                                    ChessMove(code:"h7->h6")!,
                                    
                                    ChessMove(code:"d1->f3")!,
                                    ChessMove(code:"f8->a3")!,
                                    
                                    ChessMove(code:"b2->b3")!,
                                    ChessMove(code:"a3->c1")!,
                                    
                                    ChessMove(code:"b1->c3")!
                                ]
        
        var  board = Chessboard.start()
        
        for move in moves {
            board = apply(move: move, to: board)
        }
        
        //black to move
        self.measure {
            let _ = miniMaxRoot(for: board, depth: 2, isMaximisingPlayer: true)
            
        }
    }

}
