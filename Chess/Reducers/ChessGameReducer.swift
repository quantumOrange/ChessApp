//
//  ChessGameReducer.swift
//  Chess
//
//  Created by david crooks on 08/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

enum ChessUserAction {
    case tapped(ChessboardSquare)
}

func chessgameReducer(_ value:inout GameState,_ action:ChessUserAction)  {
    switch action {
    case .tapped(let square):
        
        guard let selectedSquare = value.selectedSquare else {
            //no square is selected, so we can select the tapped square if it has the right color of piece.
            if isYourPiece(chessboard:value.chessboard , square: square) {
                value.selectedSquare = square
            }
            
            return
        }
    
        if selectedSquare == square {
            //Tapping the selected square, so toggle off!
            value.selectedSquare = nil
        } else {
            
             //We already have a selected "from" square, and so this is a proposed "to" square.
             // We have everything we need to make a move, provided the move is valid.
            
            if validate(chessboard:value.chessboard, move: ChessMove(from: selectedSquare,to:square)) {
                applyMove(board: &value.chessboard, move: ChessMove(from: selectedSquare,to:square))
                value.selectedSquare = nil
            }
        }
    }
}


