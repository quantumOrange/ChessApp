//
//  SelectedSquareReducer.swift
//  Chess
//
//  Created by David Crooks on 29/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

enum chessboardAction {
    case tap(ChessboardSquare)
   
    case clear
}

enum chessboardExoAction {
    case move(ChessMove)
    
    var move:ChessMove? {
        get {
            guard case let .move(value) = self else { return nil }
            return value
        }
        set {
            guard case .move = self, let newValue = newValue else { return }
            self = .move(newValue)
        }
    }
    
}

struct chessboardUIState {
    var chessboard:Chessboard
    var selectedSquare:ChessboardSquare?
    var gameOverAlertModel:GameOverAlertModel? = nil
}

func chessboardUIReducer(_ state:inout chessboardUIState,_ action:chessboardAction) -> [Effect<chessboardExoAction>]{
    switch action {
    
    case .tap(let square):
        
        if state.selectedSquare == square
        {
            //Tapping the selected square, so toggle off!
            state.selectedSquare = nil
        }
        else
        {
            if isYourPiece(chessboard:state.chessboard , square: square)
            {
                  //selecting a differant peice to move
                 state.selectedSquare = square
            }
            else if let selectedSquare = state.selectedSquare
            {
                //We have a selected square already
                let move =  ChessMove(from: selectedSquare,to:square)
                let effect = Effect<chessboardExoAction>
                {   callback in
                    callback(chessboardExoAction.move(move))
                }
                return [effect]
            }
        }
    case .clear:
        
        switch state.chessboard.gamePlayState {
                                   
           case .won(let player):
               state.gameOverAlertModel = GameOverAlertModel(state: .win(player), reason: .checkmate)
               break
           case .draw:
               state.gameOverAlertModel = GameOverAlertModel(state: .draw, reason: .agreement)
           case .inPlay:
               break
        }
        
        state.selectedSquare = nil
    
    }
    return []
}

