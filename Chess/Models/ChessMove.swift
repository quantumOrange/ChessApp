//
//  ChessMove.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

enum AuxilleryChessMove:Equatable {
    case none
    case promote(ChessPiece) //for pawn promotion
    case double(Move) //for castleing
}

struct ChessMove:Equatable {
    
    let from:ChessboardSquare
    let to:ChessboardSquare
    
   
    let auxillery:AuxilleryChessMove
    
    init( from:ChessboardSquare,to:ChessboardSquare, aux:AuxilleryChessMove = .none) {
        self.auxillery = aux
        self.from = from
        self.to = to
    }
}

struct Move:Equatable {
    let from:ChessboardSquare
    let to:ChessboardSquare
    
    var chessMove:ChessMove {
        ChessMove(from: from, to: to)
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

extension ChessMove {
    static var nullMove:ChessMove {
        let anySquare = ChessboardSquare(rank: ._1, file: .a)
        return ChessMove(from:anySquare, to:anySquare)
    }
}


