//
//  SelectedSquareReducer.swift
//  Chess
//
//  Created by David Crooks on 29/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

enum SelectionAction {
    case select(ChessboardSquare)
    case clear
}

struct SelectedSquareState {
    var chessboard:Chessboard
    var selectedSquare:ChessboardSquare?
}

func selectedSquareReducer(_ state:inout SelectedSquareState,_ action:SelectionAction) {
    switch action {
    
    case .select(let square):
        if state.selectedSquare == square {
            //Tapping the selected square, so toggle off!
            state.selectedSquare = nil
        } else {
            if isYourPiece(chessboard:state.chessboard , square: square) {
                    print("Selecting \(square)")
                 state.selectedSquare = square
            }
        }
    case .clear:
        state.selectedSquare = nil
    }
}

