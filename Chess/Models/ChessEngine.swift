//
//  ChessEngine.swift
//  Chess
//
//  Created by david crooks on 16/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

struct ChessEngine {
    static func pickMove(for board:Chessboard) -> ChessMove? {
        
        let moves = validMoves(chessboard:board)
        
        let multiplier:Float =  board.whosTurnIsItAnyway == .black ? -1.0 : 1.0
        
        let values = moves
                    .map{ apply( move: $0, to: board)}
                    .map { $0.evaluate()}
                    .map{ $0 + Float.random(in: -0.5...0.5) }
                    .map { $0 * multiplier }
        
        let result = zip(moves, values)
                                .sorted(by:{ $0.1 > $1.1})
                                .first
        
        if let (bestMove,_) = result {
            return bestMove
        }
        else {
            return nil
        }
    }
}

func pickMove(for board:Chessboard) -> ChessMove? {
    
    let moves = validMoves(chessboard:board)
    
    let multiplier:Float =  board.whosTurnIsItAnyway == .black ? -1.0 : 1.0
    
    let values = moves
                .map{ apply( move: $0, to: board)}
                .map { $0.evaluate()}
                .map{ $0 + Float.random(in: -0.5...0.5) }
                .map { $0 * multiplier }
    
    let result = zip(moves, values)
                            .sorted(by:{ $0.1 > $1.1})
                            .first
    
    if let (bestMove,_) = result {
        return bestMove
    }
    else {
        return nil
    }
}

func randomChessboard(_ n:Int) -> Chessboard {
    (0...n).reduce(Chessboard.start()){ board , i in
        guard let move =  pickMove(for: board) else { return board }
        return apply(move: move, to: board)
    }
}

func randomChessboard(n:Int) ->  [Chessboard] {
    (0...n)
        .map{ _ in Int.random(in: 4...20 )  }
        .map( randomChessboard )
}

func pickMove2(for board:Chessboard) -> ChessMove? {
       
    evaluateMoves(chessboard:board, depth: 3)
        .sorted()
        .first?
        .move
}

struct EvaluatedMove:Comparable {
    static func < (lhs: EvaluatedMove, rhs: EvaluatedMove) -> Bool {
        lhs.value < rhs.value
    }
    
    let move:ChessMove
    let value:Float
}

func evaluateMoves(chessboard:Chessboard, depth:Int) -> [EvaluatedMove] {
    return evaluateMovesByPoints(board: chessboard)
}

func evaluateMovesByPoints(board:Chessboard) -> [EvaluatedMove] {
    let moves = validMoves(chessboard:board)
    
    let values = moves
                .map{ apply( move: $0 ,to: board) }
                .map{ $0.evaluate()                     }
                .map{ $0 + Float.random(in: -0.5...0.5) }
              
    
    return zip(moves, values)
                .map(EvaluatedMove.init)
    
}

