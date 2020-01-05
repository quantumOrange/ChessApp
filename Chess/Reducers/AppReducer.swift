//
//  ChessGameReducer.swift
//  Chess
//
//  Created by david crooks on 08/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

let appReducer:Reducer<AppState, AppAction,AppAction> = combineReducers(
        pullback( chessReducer,             value:\.chessboard,             action: \.chess,        f:pulbackChessEnviromentAction  ),
        pullback( chessboardUIReducer,    value:\.selectedSquareState,    action: \.selection,    f:pullbackSelectionEA           ),
        pullback( gameCenterReducer,        value:\.gameCenter,             action: \.gameCenter ),
        pullback( chessClockReducer,        value:\.clocks,                   action: \.clock, f:pullbackClockExoAction)
    )
 
extension AppState {
    var selectedSquareState:chessboardUIState {
        get {
            chessboardUIState(chessboard: chessboard, selectedSquare: selectedSquare)
        }
        set {
            selectedSquare = newValue.selectedSquare
            chessboard = newValue.chessboard
            gameOverAlertModel = newValue.gameOverAlertModel
        }
    }
}

func pulbackChessEnviromentAction(_ enviromentAction:ChessExoAction ) -> AppAction {
    switch enviromentAction {
    case .clear:
        return .selection(.clear)
    case .move(let move):
        return .chess(.move(move))
    case .noValidMoves:
        return .chess(.noValidMoves)
    }
}

func pullbackSelectionEA(_ enviromentAction:chessboardExoAction ) -> AppAction {
    switch enviromentAction {
    case .move(let move):
        return .chess(.move(move))
    
    }
}

func pullbackClockExoAction(_ exo:ChessClockExoAction) -> AppAction {
    switch exo {
    case .update(let time):
        return .clock(.update(time))
    case .outOfTime(let player):
        return .chess(.timeout(player))
    }
}
 
 
 





