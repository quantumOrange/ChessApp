//
//  ChessBoard.swift
//  Chess
//
//  Created by david crooks on 01/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

struct Chessboard {
    
    struct CastelState {
        var canCastleQueenside:Bool = true;
        var canCastleKingside:Bool = true;
    }
    
    var storage:[ChessPiece?]
    
    var black:CastelState = CastelState()
    var white:CastelState = CastelState()
    
    var lastMove:ChessMove?
    
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
    
    static func random()  -> Chessboard {
        var board = Chessboard()
        board.randomise()
        return board
    }
    
    static func start() ->  Chessboard {
        var board = Chessboard()
        
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

enum ChessFile:Int,CaseIterable,Equatable {
    case a = 0,b,c,d,e,f,g,h
}

enum ChessRank:Int,CaseIterable,Equatable{
    case _1 = 0 ,_2,_3,_4,_5,_6,_7,_8
}

struct ChessboardSquare:Equatable {
    let rank:ChessRank
    let file:ChessFile
}

struct ChessMove {
    let from:ChessboardSquare
    let to:ChessboardSquare
}

func validate(chessboard:Chessboard, move:ChessMove) -> Bool {
    //TODO!
    return true
}

func move(chessboard:Chessboard, move:ChessMove) -> Chessboard {
    var board = chessboard
    
    board[move.to.file,move.to.rank] = board[move.from.file,move.from.rank]
    board[move.from.file,move.from.rank] = nil;
    board.lastMove = move
    
    return board
}

struct ChessGame {
    
    let board:Chessboard
    
    let white:User
    let black:User
    
    let history:[ChessMove]
}

