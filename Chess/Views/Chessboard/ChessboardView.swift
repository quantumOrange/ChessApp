//
//  ChessboardView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI

struct ChessboardView : View {
    @ObservedObject var store: Store<GameState,ChessUserAction>
    
    
    let width:CGFloat
    var body: some View
        {
        
              ZStack {
            
                ChessboardSquaresView(store: self.store, width: self.width)
                ChessPiecesOnBoardView(store: self.store, width: self.width)
                TappableCheckersView(store: self.store, width: self.width)
              
            }
                
        }
    
}

#if DEBUG
struct ChessoardView_Previews: PreviewProvider {
    static var previews: some View {
        ChessboardView(store:chessStore(), width:300)
    }
}
#endif

