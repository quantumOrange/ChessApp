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
    var selectedSquare:ChessboardSquare? = nil
    var players:Players = Players.dummys()
    var gamePlayState = GamePlayState.inPlay
}

extension GameState {
    var possibleDestinationSquares:[ChessboardSquare] {
        guard let selected = selectedSquare else { return [] }
        
        return validMoves(chessboard: chessboard, for: selected).map { $0.to}
            
        
    }

}


