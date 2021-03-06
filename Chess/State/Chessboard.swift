//
//  ChessBoard.swift
//  Chess
//
//  Created by david crooks on 01/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

struct Chessboard:Codable {
    
    
    
    enum GamePlayState:Equatable ,Codable {
        case won(PlayerColor)
        case draw
        // case noStarted
        // case abandoned
        case inPlay
    }
    
    struct CastelState:Codable {
        var canCastleQueenside:Bool = true;
        var canCastleKingside:Bool = true;
    }
    
    init() {
        storage = Array(repeating: nil, count: 64)
    }
    
    var gamePlayState = GamePlayState.inPlay
    
    private var storage:[ChessPiece?]
    
    var takenPieces:[ChessPiece] = []
    
    var blackCastelState:CastelState = CastelState()
    var whiteCastelState:CastelState = CastelState()
    
   
    
    var moves:[ChessMove] = []
    
    var undoStates:[[ChessboardSquare:ChessPiece?]] = []
    
    
    
   var squares:[ChessboardSquare] = {
       return (0...7).flatMap{ i in
              (0...7).map { j in
               ChessboardSquare(rank: ChessRank(rawValue: i)!, file: ChessFile(rawValue: j)!)
           }
       }
   }()
}

extension Chessboard {
    mutating func randomise() {
           (0...8).forEach{ _ in
               storage[Int.random(in: 0..<64)] = ChessPiece.random()
           }
       }
       
    var whosTurnIsItAnyway:PlayerColor {
           return moves.count.isMultiple(of: 2) ? .white : .black
       }
}

extension  Chessboard.GamePlayState {
    
    private enum CodingKeys: String, CodingKey {
        case won
        case draw
        // case noStarted
        // case abandoned
        case inPlay
    }

    enum PostTypeCodingError: Error {
        case decoding(String)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? values.decode(PlayerColor.self, forKey: .won) {
            self = .won(value)
            return
        }
        
        if let _ = try? values.decode(String.self, forKey: .draw) {
            self = .draw
            return
        }
        
        if let _ = try? values.decode(String.self, forKey: .inPlay) {
            self = .inPlay
            return
        }
        
        throw PostTypeCodingError.decoding("Whoops! \(dump(values))")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
            
        case .won(let playerColor):
            try container.encode(playerColor, forKey: .won)
        case .draw:
            try container.encode("draw", forKey: .draw)
        case .inPlay:
            try container.encode("inPlay", forKey: .inPlay)
       
        }
    }
}

//Setup a board
extension Chessboard {
    
    static func random()  -> Chessboard {
        var board = Chessboard()
        board.randomise()
        return board
    }
    
    static func start() ->  Chessboard {
        var board = Chessboard()
        
        func id(rank:ChessRank,file:ChessFile) -> Int {
            file.rawValue*8 + rank.rawValue
        }
        
        ChessFile.allCases.forEach{ file in
            board[file , ._2] = ChessPiece(player: .white, kind: .pawn, id:id(rank: ._2, file: file))
            board[file , ._7] = ChessPiece(player: .black, kind: .pawn, id:id(rank: ._7, file: file))
        }
        
        let pieces:[ChessPiece.Kind] = [.rook,.knight,.bishop,.queen,.king,.bishop,.knight,.rook]
        
        zip(ChessFile.allCases,pieces).forEach{ (file,kind) in
            board[file , ._1] = ChessPiece(player: .white, kind: kind, id:id(rank: ._1, file: file))
            board[file , ._8] = ChessPiece(player: .black, kind: kind, id:id(rank: ._8, file: file))
        }
        
        return board
    }
       
}

extension Chessboard {
    func evaluate() -> Float {
        return storage
                    .compactMap{$0?.value }
                    .reduce(0, +)
    }
}

//subscripts
extension Chessboard {
    
    subscript(square:ChessboardSquare) ->ChessPiece? {
           get {
               return storage[square.file.rawValue*8+square.rank.rawValue]
           }
                  
          set {
               storage[square.file.rawValue*8+square.rank.rawValue] = newValue
          }
       }
       
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
}


enum ChessFile:Int,CaseIterable,Equatable,Codable{
    
    init?(code:String) {
        switch code {
        case "a":
            self = .a
        case "b":
            self = .b
        case "c":
            self = .c
        case "d":
            self = .d
        case "e":
            self = .e
        case "f":
            self = .f
        case "g":
            self = .g
        case "h":
            self = .h
        default:
            return nil
        }
    }
    
    case a = 0,b,c,d,e,f,g,h
}

extension ChessFile:CustomStringConvertible {
    var description: String {
         switch self {
         case .a:
            return "a"
         case .b:
            return "b"
         case .c:
            return "c"
         case .d:
            return "d"
         case .e:
            return "e"
         case .f:
            return "f"
         case .g:
            return "g"
         case .h:
            return "h"
        }
    }
}

enum ChessRank:Int,CaseIterable,Equatable,Codable {
    case _1 = 0 ,_2,_3,_4,_5,_6,_7,_8
    
    init?(code:String) {
        let invalidRawValue = -1
        guard let rank =  ChessRank(rawValue: ( Int(code) ?? invalidRawValue ) - 1 ) else { return nil }
        self = rank
    }
}

extension ChessRank:CustomStringConvertible {
    var description: String {
        "\(rawValue + 1)"
    }
}

extension ChessRank:Identifiable {
    var id: Int {
        rawValue
    }
}

extension ChessFile:Identifiable {
    var id: Int {
        rawValue
    }
}



struct ChessGame {
    
    let board:Chessboard
    
    let white:User
    let black:User
    
    let history:[ChessMove]
}


extension Chessboard: CustomStringConvertible {
    var description: String {
        //var boardDescription = "------------------------\n"
        var boardDescription = ""
        for i in 0...7 {
            let rank = 7 - i
            var rankDescription = ""
            for file in 0...7 {
                let piece = self[file,rank]
                //let emptySquare = (file+rank).isMultiple(of: 2) ? "◻︎" :"◼︎"
                let emptySquare = "."
                let pieceStr = piece?.symbol ?? emptySquare
                
                rankDescription += " \(pieceStr) "
            }
            rankDescription += "\n"
            boardDescription += rankDescription
        }
        //boardDescription +=  "------------------------\n"
        return boardDescription
    }
}

extension Chessboard
{
    init?(string:String)
    {
        storage = Array(repeating: nil, count: 64)
        
        let piecesAndSpaces = string
                                .trimmingCharacters(in: .alphanumerics)
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                                .components(separatedBy: CharacterSet.whitespacesAndNewlines)
                                .filter{!$0.isEmpty}
                                .enumerated()
                                .map(ChessPiece.init)
        
        guard piecesAndSpaces.count == 64 else { return nil  }
        
        // Now we have the right pieces, but the board is flipped.
        // So we  need to transpose:
        for i in 0...7
        {
            for j in 0...7
            {
                let k = i*8 + 7 - j
                let t = j*8 + i
                storage[k] = piecesAndSpaces[t]
            }
        }
    }
}

extension Chessboard {
    //same, but may not be identically equal. We don't care about id.
    func same(as other:Chessboard) -> Bool
    {
        func samePieces(_ pieces:(ChessPiece?,ChessPiece?))-> Bool
        {
            guard   let left  = pieces.0,
                    let right = pieces.1
            else
            {
               return (pieces.0 == nil && pieces.0 == nil)
            }
            return left.same(as: right)
        }
        
        return zip(self.storage,other.storage).allSatisfy(samePieces)
    }
}

extension Chessboard {

    func logStorage()
    {
        print(storage.map{$0?.symbol})
    }
}


extension Chessboard
{
    mutating func setCannotCastle(player:PlayerColor, side:CastleSide)
    {
        switch player
        {
        case .white:
            switch side
            {
            case .kingside:
                 whiteCastelState.canCastleKingside = false
            case .queenside:
                 whiteCastelState.canCastleQueenside = false
            }
        case .black:
            switch side
            {
            case .kingside:
                 blackCastelState.canCastleKingside = false
            case .queenside:
                 blackCastelState.canCastleQueenside = false
            }
        }
    }
}
