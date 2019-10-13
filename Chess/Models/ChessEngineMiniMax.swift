//
//  ChessEngineMiniMax.swift
//  Chess
//
//  Created by David Crooks on 12/10/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation


func pickMoveMiniMax(for board:Chessboard) -> ChessMove? {
    let depth = 2
    //let multiplier:Float =  board.whosTurnIsItAnyway == .black ? -1.0 : 1.0
     print("minimaxing")
    return miniMaxRoot(for: board, depth: depth, isMaximisingPlayer: true)
  
}



func miniMaxRoot(for board:Chessboard, depth:Int, isMaximisingPlayer:Bool) -> ChessMove? {
    let moves = validMoves(chessboard:board)
   
    //let multiplier:Float =  board.whosTurnIsItAnyway == .black ? -1.0 : 1.0
    
   let values = moves
                    .map{ apply( move: $0, to: board)}
                    .map{ immutableBoard -> Float in
                            var mutableBoard = immutableBoard
                            return miniMax(for: &mutableBoard, depth: depth,isMaximisingPlayer:true )
                        }
                
   let result = zip(moves, values)
                    .max(by:{ $0.1 < $1.1})
    
    
    if let (bestMove,_) = result {
         print("returning")
        return bestMove
    }
    else {
        print("NO MOVE FOUND")
        return nil
    }
    
}


func miniMax(for board:inout Chessboard, depth:Int, isMaximisingPlayer:Bool) -> Float {
    
    let moves = validMoves(chessboard:board)
    
    if depth == 0 {
        return 23.4
        //return -board.evaluate()
    }
    
     let values = moves.map { move -> Float in
                                board.applyTemp(move: move)
                                let value = miniMax(for: &board, depth: depth-1 , isMaximisingPlayer:!isMaximisingPlayer )
                                board.undoTempMove()
                                return value
                            }
    
    let value =  isMaximisingPlayer ?  values.max() : values.min()
    
    return value ?? 0
}




