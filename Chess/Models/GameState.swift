//
//  GameState.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

struct GameState {
    var chessboard:Chessboard =  Chessboard.start()
    
    var players:Players = Players.dummys()
    var gamePlayState = GamePlayState.inPlay
}

enum GamePlayState {
    case won(PlayerColor)
    case draw
  //  case noStarted
  // case abandoned
    case inPlay
}

func gamePlayState(chessboard:Chessboard) -> GamePlayState {
    
    let checked = isInCheck(chessboard: chessboard, player:chessboard.whosTurnIsItAnyway)
    
    let currentPlayerCanMove = validMoves(chessboard:chessboard).count > 0
    
    if checked && !currentPlayerCanMove {
        //checkmate!
        return .won(!(chessboard.whosTurnIsItAnyway))
    }
    
    if !checked && !currentPlayerCanMove {
        return .draw
    }
    return .inPlay
}



