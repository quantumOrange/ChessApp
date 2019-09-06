//
//  ContentView.swift
//  Chess
//
//  Created by david crooks on 01/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI
import Combine




struct ContentView : View {
    @ObservedObject var game: GameState
    
    var body: some View {
        ChessGameView(game:game)
    }
}




#if DEBUG
struct ContentView_Previews : PreviewProvider {
    
    static var previews: some View {
        ContentView(game: GameState())
    }
}
#endif


