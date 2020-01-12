//
//  ChessPiece.swift
//  Chess
//
//  Created by david crooks on 01/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation


struct ChessPiece:Equatable,Identifiable,Codable {
   
    
    enum Kind:String,Equatable,CaseIterable,Codable {
        case pawn
        case knight
        case bishop
        case rook
        case queen
        case king
    }
    
    let player:PlayerColor
    
    let kind:Kind
    
    let id:Int
    
    init(player: PlayerColor, kind:Kind, id: Int){
        self.player = player
        self.kind = kind
        self.id = id
    }
    
    init?(id:Int, symbol:String){
        func kind(symbol:String)->Kind? {
            switch symbol {
            case "♙","♟":
                return .pawn
            case "♘","♞":
                return .knight
            case "♗","♝":
                return .bishop
            case "♖","♜":
                return .rook
            case "♕","♛":
                return  .queen
            case "♔","♚":
                return .king
            default:
                return nil
            }
        }
        
        func color(symbol:String)->PlayerColor? {
            switch symbol {
            case "♙","♘","♗","♖","♕","♔":
                return .white
            case "♟","♞","♝","♜","♛","♚":
                return .black
            default:
                return nil
            }
        }
        
        guard let color = color(symbol: symbol),
             let kind = kind(symbol: symbol) else { return nil }
        
        self.kind = kind
        self.player = color
        self.id = id

    }
    
    
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
    
    var value:Float {
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
            return 90.0
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
                          kind: Kind.allCases.randomElement()!, id:Int.random(in: 0...63))
    }
    
}

extension ChessPiece {
    //same, but may not be identically equal. We don't care about id.
    func same(as other:ChessPiece) -> Bool {
        return (self.kind == other.kind && self.player == other.player)
    }
}
