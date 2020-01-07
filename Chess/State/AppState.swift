//
//  GameState.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

struct ChessGameState {
    var chessboard:Chessboard =  Chessboard.start()
    var players:Players = Players.dummys()
    var playerPointOfView:PlayerColor = .white
}

struct AppState {
    var chessboard:Chessboard =  Chessboard.start()
    var user = User.david()
    var users:[User] = []
    var selectedSquare:ChessboardSquare?
    var players:Players = Players.dummys()
    var playerPointOfView:PlayerColor = .white
    var gameCenter:GameCenterState = GameCenterState()
    var gameOverAlertModel:GameOverAlertModel? = nil
    var clocks: ChessClockState =  ChessClockState(time:60)
}

func gamePlayState(chessboard:Chessboard) -> Chessboard.GamePlayState {
    
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



