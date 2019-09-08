//
//  ChessMove.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

struct ChessMove {
    let from:ChessboardSquare
    let to:ChessboardSquare
}

func validate(chessboard:Chessboard, move:ChessMove) -> Bool {
    
    guard let thePieceToMove = chessboard[move.from] else {
        //You can't move nothing
        return false
    }
    
    if let thePieceToCapture = chessboard[move.to] {
        if thePieceToMove.player == thePieceToCapture.player {
            //you can't capture your own piece
            return false
        }
    }
    
    switch thePieceToMove.kind {
   
    case .pawn:
        return true
    case .knight:
        return true
    case .bishop:
        return true
    case .rook:
        return true
    case .queen:
        return true
    case .king:
        return true
    
    }
    
}



func move(chessboard:Chessboard, move:ChessMove) -> Chessboard {
    var board = chessboard
    
    board[move.to.file,move.to.rank] = board[move.from.file,move.from.rank]
    board[move.from.file,move.from.rank] = nil;
    board.lastMove = move
    
    return board
}


enum ChessAction {
    case move(ChessMove)
}

func chessReducer( board:inout Chessboard, action:ChessAction)  {
    switch action {
    case .move(let move):
        board[move.to.file,move.to.rank] = board[move.from.file,move.from.rank]
        board[move.from.file,move.from.rank] = nil;
        board.lastMove = move
    }
}





