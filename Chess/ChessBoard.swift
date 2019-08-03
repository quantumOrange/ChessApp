//
//  ChessBoard.swift
//  Chess
//
//  Created by david crooks on 01/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

struct ChessBoard {
    
    struct CastelState {
        var canCastleQueenside:Bool = true;
        var canCastleKingside:Bool = true;
    }
    
    var storage:[ChessPiece?]
    
    var black:CastelState = CastelState()
    var white:CastelState = CastelState()
    
    //var lastMove:Move?
    subscript(file:ChessFile, rank:ChessRank)->ChessPiece? {
        
        get {
            return storage[file.rawValue*8+rank.rawValue]
        }
        
        set {
            storage[file.rawValue*8+rank.rawValue] = newValue
        }
        
    }
    
     
    subscript(_ file:Int ,_ rank:Int)->ChessPiece? {
        
        get {
            return storage[file*8+rank]
        }
        
        set {
            storage[file*8+rank] = newValue
        }
        
    }
    
    init() {
        storage = Array(repeating: nil, count: 64)
    }
    
    mutating func randomise() {
        (0...8).forEach{ _ in
            storage[Int.random(in: 0..<64)] = ChessPiece.random()
        }
    }
    
    static func random()  -> ChessBoard {
        var board = ChessBoard()
        board.randomise()
        return board
    }
    
    static func start() ->  ChessBoard {
        var board = ChessBoard()
        
        ChessFile.allCases.forEach{ file in
            board[file , ._2] = ChessPiece(player: .white, kind: .pawn)
            board[file , ._7] = ChessPiece(player: .black, kind: .pawn)
        }
        
        let pieces:[ChessPiece.Kind] = [.rook,.bishop,.knight,.queen,.king,.knight,.bishop,.rook]
        
        zip(ChessFile.allCases,pieces).forEach{ (file,kind) in
            board[file , ._1] = ChessPiece(player: .white, kind: kind)
            board[file , ._8] = ChessPiece(player: .black, kind: kind)
        }
        
        return board
    }
}

enum ChessFile:Int,CaseIterable {
    case a = 0,b,c,d,e,f,g,h
}

enum ChessRank:Int,CaseIterable {
    case _1 = 0 ,_2,_3,_4,_5,_6,_7,_8
}


