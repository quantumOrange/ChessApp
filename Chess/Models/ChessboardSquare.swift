//
//  ChessboardSquare.swift
//  Chess
//
//  Created by david crooks on 15/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

struct ChessboardSquare:Equatable {
    let rank:ChessRank
    let file:ChessFile
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
    var squares:[ChessboardSquare] {
        return (0...7).flatMap{ i in
               (0...7).map { j in
                ChessboardSquare(rank: ChessRank(rawValue: i)!, file: ChessFile(rawValue: j)!)
            }
        }
    }
}

