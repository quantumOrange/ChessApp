//
//  ChessGameView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI

func liftChessboardAction(_ localAction:SelectionAction ) -> AppAction {
    switch localAction {
    
    case .tap(let square):
        return .selection(.tap(square))
    case .clear:
        return .selection(.clear)
    
    }
}

struct ChessGameView : View {
    @ObservedObject var store: Store<AppState,AppAction>
    @ObservedObject var alertModle:AlertModel<GameOverAlertModel>
   
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing:50 ){
                PlayerView(name:"Mr Black", player:.black)
                ChessboardView(store: self.store.wormhole(focus:idState, lift:liftChessboardAction),width:geometry.size.width)
                PlayerView(name:"Mr White", player:.white)
            }
        }.alert(item:self.$alertModle.value) { alert in
            
            
            Alert(title: Text("Game Over"), message: Text(alert.text), dismissButton: .default(Text("OK")))
        }
    }
}


#if DEBUG
struct ChessGameView_Previews: PreviewProvider {
    static var previews: some View {
        ChessGameView(store:chessStore(),alertModle: AlertModel<GameOverAlertModel>())
    }
}
#endif
