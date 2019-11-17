//
//  ChessGameReducer.swift
//  Chess
//
//  Created by david crooks on 08/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation



extension AppState {
    
    var selectedSquareState:SelectedSquareState {
        get {
            SelectedSquareState(chessboard: chessboard, selectedSquare: selectedSquare)
        }
        set {
            selectedSquare = newValue.selectedSquare
            chessboard = newValue.chessboard
        }
    }
}
 
let appReducer:Reducer<AppState, AppAction> = combineReducers(
        pullback( chessReducer,             value:\.chessboard,             action: \.chess     ),
        pullback( selectedSquareReducer,    value:\.selectedSquareState,    action: \.selection ),
        pullback( gameCenterReducer,        value:\.gameCenter,             action: \.gameCenter )
    )
 
 
 
 
 
 





