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
        
        
        switch move.auxillery {
            
        case .none:
           
            board[move.to] = pieceToMove
            
        case .promote(let kind):
            
             board[move.to] = ChessPiece(player: pieceToMove.player, kind:kind, id: pieceToMove.id)
            
        case .double(let secondMove):
           

            board[move.to] = pieceToMove
            
            if let secondPieceToMove = board[secondMove.from] {
              
                board[secondMove.from] = nil;
                board[secondMove.to] = secondPieceToMove
            }
            
        
        }
        
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
         if let validatedMove = validate(chessboard:board, move:move) {
            board = apply(move:validatedMove, to: board)
         }
    }
}

