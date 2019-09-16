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
        
        return moves.randomElement()
    }
}

