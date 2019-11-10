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
    case promote(ChessPiece.Kind) //for pawn promotion
    case double(Move) //for castleing
}

struct ChessMove:Equatable,CustomStringConvertible {
    
    var description: String {
        "\(from)->\(to)"
    }
    
    let from:ChessboardSquare
    let to:ChessboardSquare
    
    let auxillery:AuxilleryChessMove
    
    init( from:ChessboardSquare,to:ChessboardSquare, aux:AuxilleryChessMove = .none) {
        self.auxillery = aux
        self.from = from
        self.to = to
    }
    
    init?(code:String) {
        self.auxillery = .none
        guard   let from    = ChessboardSquare(code:String(code.prefix(2))),
                let to      = ChessboardSquare(code:String(code.suffix(2)))
                                                                    else { return nil }
        self.from = from
        self.to = to
    }
    
    var promotion:ChessPiece.Kind? {
        guard case .promote(let piece) = auxillery else { return nil }
        return piece
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


