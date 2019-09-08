//
//  AppStore.swift
//  Chess
//
//  Created by david crooks on 08/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation


extension Store {
    static func chessStore() -> Store<GameState,ChessGameAction > {
      Store<GameState,ChessGameAction >(initialValue: GameState(), reducer:chessgameReducer )
    }
}
