//
//  ChessGameReducer.swift
//  Chess
//
//  Created by david crooks on 08/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

enum AppAction {
    case chess(ChessAction)
    case selection(SelectionAction)
}

extension AppAction {
    var chess:ChessAction? {
        get {
            guard case let .chess(value) = self else { return nil }
            return value
        }
        set {
            guard case .chess = self, let newValue = newValue else { return }
            self = .chess(newValue)
        }
    }
    
    var selection:SelectionAction? {
        get {
            guard case let .selection(value) = self else { return nil }
            return value
        }
        set {
            guard case .selection = self, let newValue = newValue else { return }
            self = .selection(newValue)
        }
    }
}

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
        pullback( selectedSquareReducer,    value:\.selectedSquareState,    action: \.selection )
    )
 
 
 
 
 
 





