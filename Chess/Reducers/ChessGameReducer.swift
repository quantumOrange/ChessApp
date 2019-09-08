//
//  ChessGameReducer.swift
//  Chess
//
//  Created by david crooks on 08/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

enum ChessGameAction {
    case tappedSquare(ChessboardSquare)
}


func chessgameReducer(_ board:inout GameState,_ action:ChessGameAction)  {
    fatalError("unimplemented")
}
