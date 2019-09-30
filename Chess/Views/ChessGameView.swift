//
//  ChessGameView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI

func liftChessboardAction(_ localAction:ChessboardAction ) -> AppAction {
    switch localAction {
    
    case .select(let square):
        return .selection(.select(square))
    case .move(let move):
        return .chess(.move(move))
    
    }
}

struct ChessGameView : View {
    @ObservedObject var store: Store<AppState,AppAction>
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing:50 ){
                PlayerView(name:"Mr Black", player:.black)
                ChessboardView(store: self.store.wormhole(focus:idState, lift:liftChessboardAction),width:geometry.size.width)
                PlayerView(name:"Mr White", player:.white)
            }
        }
    }
}


#if DEBUG
struct ChessGameView_Previews: PreviewProvider {
    static var previews: some View {
        ChessGameView(store:chessStore())
    }
}
#endif
