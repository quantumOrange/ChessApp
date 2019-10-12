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

func files(orientatedFor pointOfView:PlayerColor) -> [ChessFile] {
    switch pointOfView {
    case .white:
        return  ChessFile.allCases
    case .black:
        return  ChessFile.allCases.reversed()
    }
}

func ranks(orientatedFor pointOfView:PlayerColor) -> [ChessRank] {
     switch pointOfView {
     case .white:
         return  ChessRank.allCases.reversed()
     case .black:
         return  ChessRank.allCases
     }
}

struct ChessboardView : View {
    @ObservedObject var store: Store<AppState,ChessboardAction>

    let width:CGFloat
    var body: some View
        {
              ZStack {
                ChessboardSquaresView(store: self.store.wormhole(focus:idState, lift:absurdAppState), width: self.width)
                ChessPiecesOnBoardView(store: self.store.wormhole(focus:idState, lift:absurdAppState), width: self.width)
                TappableCheckersView(store: self.store.wormhole(focus: {TappableBoardState(selectedSquare: $0.selectedSquare, playerPointOfView: $0.playerPointOfView)  }, lift: idAction), width: self.width)
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
