//
//  AppStore.swift
//  Chess
//
//  Created by david crooks on 08/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation


    func chessStore() -> Store<GameState,AppAction > {
      Store<GameState,AppAction >(initialValue: GameState(), reducer:appReducer )
    }

