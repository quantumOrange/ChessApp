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
    let simpleMoves = [
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
    
    var developedBoard:Chessboard!
    
    override func setUp() {
        
        developedBoard = Chessboard.start()
        
        for move in simpleMoves {
            developedBoard  = apply(move: move, to: developedBoard )
        }
    }

    override func tearDown() {
        developedBoard = nil
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
        self.measure {
            let _ = validMoves(chessboard: developedBoard)
        }
    }

func testPerformanceUncheckedValidMoves() {
        self.measure {
            let _ = uncheckedValidMoves(chessboard:developedBoard)
        }
    }

   
    func testPerformancValidPawnMoves() {
        self.measure {
            for square in developedBoard.squares {
               if developedBoard[square]?.kind == .pawn {
                   let _ = validPawnMoves(board:developedBoard, square: square)
                }
            }
           
        }
    }
    
    func testPerformancValidRookMoves() {
        self.measure {
            for square in developedBoard.squares {
                if developedBoard[square]?.kind == .rook  && developedBoard[square]?.player == developedBoard.whosTurnIsItAnyway {
                    let _ = validRookMoves(board:developedBoard, square: square)
                }
            }
           
        }
    }
    
    func testPerformancValidKingMoves() {
        self.measure {
            for square in developedBoard.squares {
                if developedBoard[square]?.kind == .king {
                     let _ = validKingMoves(board:developedBoard, square: square)
                }
               
            }
           
        }
    }
    
    func testPerformancValidBishopMoves() {
        self.measure {
            for square in developedBoard.squares {
                
                let _ = validBishopMoves(board:developedBoard, square: square)
            }
           
        }
    }
    
    func testPerformancValidKnightMoves() {
        self.measure {
            for square in developedBoard.squares {
                let _ = validKnightMoves(board:developedBoard, square: square)
            }
           
        }
    }
    
    func testPerformancValidQueenMoves() {
        self.measure {
            for square in developedBoard.squares {
                let _ = validQueenMoves(board:developedBoard, square: square)
            }
           
        }
    }
    /*
     func validMoves(chessboard:Chessboard, for square:ChessboardSquare) -> [ChessMove] {
         guard let piece = chessboard[square],
             piece.player == chessboard.whosTurnIsItAnyway
                 else { return [] }
         
         //TODO : check/pinned to king?? // perhaps best done as a filter at the end
         
         switch piece.kind {
         
         case .pawn:
              return validPawnMoves(board: chessboard, square: square)
         case .knight:
              return validKnightMoves(board: chessboard, square: square)
         case .bishop:
              return validBishopMoves(board: chessboard, square: square)
         case .rook:
              return validRookMoves(board: chessboard, square: square)
         case .queen:
              return validQueenMoves(board: chessboard, square: square)
         case .king:
              return validKingMoves(board: chessboard, square: square)
         
         }
         
     }
     */
}
