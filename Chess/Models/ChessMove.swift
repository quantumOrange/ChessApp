//
//  ChessMove.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

struct ChessMove:Equatable {
    let from:ChessboardSquare
    let to:ChessboardSquare
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



