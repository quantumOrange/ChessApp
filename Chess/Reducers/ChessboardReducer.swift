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
        board.moves.append(move)
    }
}


func apply(move:ChessMove, to board:Chessboard) -> Chessboard {
    var board = board
    
    if let pieceToMove = board[move.from] {
        board[move.from] = nil;
        board[move.to] = pieceToMove
    }
    
    board.moves.append(move)
    
    return board
}

enum ChessAction {
    case move(ChessMove)
}

func chessReducer( board:inout Chessboard, action:ChessAction)  {
    switch action {
    case .move(let move):
         if validate(chessboard:board, move:move) {
            board = apply(move: move, to: board)
         }
    }
}

