//
//  ChessPiece.swift
//  Chess
//
//  Created by david crooks on 01/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

enum PlayerColor:Equatable {
    case white
    case black
}

prefix func !(v:PlayerColor)-> PlayerColor {
    switch v {
    case .white:
        return .black
    case .black:
        return .white
    }
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
    
    let player:PlayerColor
    
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
        var absValue:Float = 0.0
        switch kind {
        case .pawn:
            absValue = 1.0
        case .knight:
            absValue = 3.0
        case .bishop:
            absValue = 3.1
        case .rook:
            absValue = 5.0
        case .queen:
            absValue = 9.0
        case .king:
            return nil
        }
        
        switch player {
        case .white:
            return absValue
        case .black:
            return -absValue
        }
    }
}

extension ChessPiece {

    static func random() -> ChessPiece {
        return ChessPiece(player: Bool.random() ?PlayerColor.black : PlayerColor.white,
                          kind: Kind.allCases.randomElement()!)
    }
    
}
