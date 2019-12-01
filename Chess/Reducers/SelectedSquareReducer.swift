//
//  SelectedSquareReducer.swift
//  Chess
//
//  Created by David Crooks on 29/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

enum SelectionAction {
    case tap(ChessboardSquare)
   
    case clear
}

enum SelectionEA {
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


struct SelectedSquareState {
    var chessboard:Chessboard
    var selectedSquare:ChessboardSquare?
}

func selectedSquareReducer(_ state:inout SelectedSquareState,_ action:SelectionAction) -> [Effect<SelectionEA>]{
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
                let effect = Effect<SelectionEA>
                {   callback in
                    callback(SelectionEA.move(move))
                }
                return [effect]
            }
        }
    case .clear:
        state.selectedSquare = nil
    
    }
    return []
}

