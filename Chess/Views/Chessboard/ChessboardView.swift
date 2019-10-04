//
//  ChessboardView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI
import Combine


enum ChessboardAction {
    case select(ChessboardSquare)
    case move(ChessMove)
}

func absurdAppState(_ never:Never) -> ChessboardAction {
    switch never {}
}

func idAction(_ a:ChessboardAction) -> ChessboardAction {
    return a
}

func idState(_ v:AppState) -> AppState {
    return v
}

struct ChessboardView : View {
    @ObservedObject var store: Store<AppState,ChessboardAction>
 /*
    func foo() {
        
           
    }
   
    */
    let width:CGFloat
    var body: some View
        {
            //foo()
              ZStack {
                ChessboardSquaresView(store: self.store.wormhole(focus:idState, lift:absurdAppState), width: self.width)
                ChessPiecesOnBoardView(store: self.store.wormhole(focus:idState, lift:absurdAppState), width: self.width)
                TappableCheckersView(store: self.store.wormhole(focus: {$0.selectedSquare}, lift: idAction), width: self.width)
            }
                
        }
    
}
/*
#if DEBUG

struct ChessoardView_Previews: PreviewProvider {
    static var previews: some View {
        ChessboardView(store:chessStore(), width:300)
    }
}
#endif

*/
