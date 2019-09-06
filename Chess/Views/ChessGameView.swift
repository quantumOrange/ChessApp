//
//  ChessGameView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI

struct ChessGameView : View {
    @ObservedObject var game: GameState
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing:50 ){
                PlayerView(name:"Mr Black", player:.black)
                ChessboardView(board: self.$game.chessboard,width:geometry.size.width)
                PlayerView(name:"Mr White", player:.white)
            }
        }
    }
}


#if DEBUG
struct ChessGameView_Previews: PreviewProvider {
    static var previews: some View {
        ChessGameView(game:GameState())
    }
}
#endif
