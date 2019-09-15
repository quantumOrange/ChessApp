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
    
    if !isYourPiece(chessboard: chessboard, move: move) {
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

func isYourPiece(chessboard:Chessboard, move:ChessMove) -> Bool {
    return isYourPiece(chessboard: chessboard, square: move.from)
}

func isYourPiece(chessboard:Chessboard, square:ChessboardSquare) -> Bool {
    guard let thePieceToMove = chessboard[square] else {
        //You can't move nothing
        return false
    }
    
    return chessboard.whosTurnIsItAnyway == thePieceToMove.player
}



