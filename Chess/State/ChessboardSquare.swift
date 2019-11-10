//
//  ChessboardSquare.swift
//  Chess
//
//  Created by david crooks on 15/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

struct ChessboardSquare:Equatable,Hashable {
    let rank:ChessRank
    let file:ChessFile
    
    init(rank:ChessRank, file: ChessFile){
        self.rank = rank
        self.file = file
    }
}

extension ChessboardSquare {
    // ChessboardSquare(rank: newRank, file: newFile)
    init?(code:String){
        let invalidRawValue = -1
        guard   let rank = ChessRank(code:String(code.suffix(1))),
                let file = ChessFile(code:String(code.prefix(1)))     else { return nil }
        
        self.rank = rank
        self.file = file
    }
}



extension ChessboardSquare {
    
    // Directions viewed from whites perspective
    enum Direction:CaseIterable {
        case top,bottom,left,right
        case bottomLeft,bottomRight,topLeft,topRight
    }
    
    func getNeighbour(_ direction:Direction) -> ChessboardSquare? {
        
        var rawRank = rank.rawValue
        var rawFile = file.rawValue
        
        switch direction {
        
        case .top:
            rawRank += 1
        case .bottom:
            rawRank -= 1
        case .left:
            rawFile -= 1
        case .right:
            rawFile += 1
        case .topLeft:
            rawFile -= 1
            rawRank += 1
        case .topRight:
            rawFile += 1
            rawRank += 1
        case .bottomLeft:
            rawFile -= 1
            rawRank -= 1
        case .bottomRight:
            rawFile += 1
            rawRank -= 1
        }
        
        if let newRank = ChessRank(rawValue: rawRank),
            let newFile = ChessFile(rawValue: rawFile) {
             return ChessboardSquare(rank: newRank, file: newFile)
        }
        
        return nil
    }
}

extension Chessboard {
   
    
    func squares(with piece:ChessPiece) -> [ChessboardSquare] {
        squares.filter{
            guard let otherPiece = self[$0]  else { return false }
            return ( otherPiece.kind == piece.kind && otherPiece.player == piece.player )
        }
    }
}


extension ChessboardSquare:CustomStringConvertible {
    var description: String {
        "\(file)\(rank)"
    }
}
