//
//  ChessboardSquaresView.swift
//  Chess
//
//  Created by david crooks on 22/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI

struct ChessboardSquaresView: View {
    
    @ObservedObject var store: Store<GameState,ChessUserAction>
         
         
    let width:CGFloat
    

    var body: some View {
        HStack(alignment: .center,spacing:0)
                       {
                           ForEach((0..<8))
                           { i in
                               
                               
                               VStack(alignment: .center, spacing:0)
                               {
                                   ForEach((0..<8)) { j in
                                       
                                                   ChessSquareView(
                                                             store: self.store,
                                                       squareColor: SquareColor.at(file: i, rank: 7-j),file: i, rank: 7-j,width:self.width/8.0)
                                       
                                                   }
                                   
                                   
                               }
                               
                           }
                       }.animation(.easeInOut(duration: 2.0))
    }
}


struct ChessboardTappableSquaresView: View {
    
    @ObservedObject var store: Store<GameState,ChessUserAction>
         
         
    let width:CGFloat
    

    var body: some View {
        HStack(alignment: .center,spacing:0)
                       {
                           ForEach((0..<8))
                           { i in
                               
                               
                               VStack(alignment: .center, spacing:0)
                               {
                                   ForEach((0..<8)) { j in
                                       
                                                   ChessSquareView(
                                                             store: self.store,
                                                       squareColor: nil,file: i, rank: 7-j,width:self.width/8.0)
                                       
                                                   }
                                   
                                   
                               }
                               
                           }
        }.animation(.easeInOut(duration: 0.2))
    }
}
