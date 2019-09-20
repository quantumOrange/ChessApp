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
                    .map{ applyMove(board: board, move: $0)}
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

