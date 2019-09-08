//
//  ChessMoveReducer.swift
//  Chess
//
//  Created by david crooks on 08/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

func chessboardReducer( board:inout Chessboard, action:ChessAction)  {
    switch action {
    case .move(let move):
        board[move.to.file,move.to.rank] = board[move.from.file,move.from.rank]
        board[move.from.file,move.from.rank] = nil;
        board.lastMove = move
    }
}
