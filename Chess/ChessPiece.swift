//
//  ChessPiece.swift
//  Chess
//
//  Created by david crooks on 01/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

enum Player:Equatable {
    case white
    case black
}

struct ChessPiece:Equatable {
    
    
    
    enum Kind:Equatable,CaseIterable {
        case pawn
        case knight
        case bishop
        case rook
        case queen
        case king
    }
    
    let player:Player
    
    let kind:Kind
    
}

extension ChessPiece:CustomStringConvertible {
    var description:String {
        return "\(player) \(kind)"
    }
}

extension ChessPiece {
    
    var symbol:String {
        switch player {
            
        case .white:
            switch kind {
            case .pawn:
                return "♙"
            case .knight:
                return "♘"
            case .bishop:
                return "♗"
            case .rook:
                return "♖"
            case .queen:
                return "♕"
            case .king:
                return "♔"
            }
            
        case .black:
            switch kind {
            case .pawn:
                return "♟"
            case .knight:
                return "♞"
            case .bishop:
                return "♝"
            case .rook:
                return "♜"
            case .queen:
                return "♛"
            case .king:
                return "♚"
            }
        }
    }
    
    
    var value:Float? {
        switch kind {
        case .pawn:
            return 1.0
        case .knight:
            return 3.0
        case .bishop:
            return 3.0
        case .rook:
            return 5.0
        case .queen:
            return 9.0
        case .king:
            return nil
        }
    }
}

extension ChessPiece {

    static func random() -> ChessPiece {
        return ChessPiece(player: Bool.random() ?Player.black : Player.white,
                          kind: Kind.allCases.randomElement()!)
    }
    
}
