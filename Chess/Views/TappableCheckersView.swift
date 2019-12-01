//
//  TappableCheckersView.swift
//  Chess
//
//  Created by David Crooks on 28/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI

struct TappableBoardState{
    var selectedSquare:ChessboardSquare?
    var playerPointOfView:PlayerColor
}

struct TappableCheckersView: View {
    
    @ObservedObject var store: Store<TappableBoardState,SelectionAction>
    
    let width:CGFloat
    
    var squareWidth:CGFloat {
        return width/8.0
    }
    
    var body: some View {
        HStack(alignment: .center,spacing:0)
                       {
                        ForEach(files(orientatedFor:self.store.value.playerPointOfView))
                           { file in
                               
                               VStack(alignment: .center, spacing:0)
                               {
                                ForEach(ranks(orientatedFor:self.store.value.playerPointOfView)) { rank in
                                       
                                                   Button(action:{
                                                    self.store.send(.tap(ChessboardSquare(rank:rank, file:file)))
                                                   // self.selectOrMove(to:ChessboardSquare(rank:rank, file:file))
                                                   } ){
                                                    Spacer().frame(width:self.squareWidth,height: self.squareWidth)
                                                       }
                                                   .frame(width:self.squareWidth, height: self.squareWidth, alignment: .center)
                                       
                                                   }
                                      
                               }
                           }
        }.animation(.easeInOut(duration: 0.3))
    }
}

