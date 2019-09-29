//
//  TappableCheckersView.swift
//  Chess
//
//  Created by David Crooks on 28/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI
struct TappableCheckersView: View {
    
    @ObservedObject var store: Store<GameState,AppAction>
         
    @Binding var selectedSquare:ChessboardSquare?
    
    let width:CGFloat
    
    var squareWidth:CGFloat {
        return width/8.0
    }
    
    func selectOrMove(to square:ChessboardSquare, board:Chessboard ) {
        guard let selectedSquare = selectedSquare else {
                   //no square is selected, so we can select the tapped square if it has the right color of piece.
                    print("No square is selected")
                   if isYourPiece(chessboard:board , square: square) {
                     print("Selecting \(square)")
                        self.selectedSquare = square
                   }
                   
                   return
               }
           
               if selectedSquare == square {
                   //Tapping the selected square, so toggle off!
                self.selectedSquare = nil
               } else {
                   print("We have a selected square and we will apply a move")
                    //We already have a selected "from" square, and so this is a proposed "to" square.
                    // We have everything we need to make a move, provided the move is valid.
                   
                if let validatedMove = validate(chessboard:store.value.chessboard, move: ChessMove(from: selectedSquare,to:square)) {
                    print("Apply validated move \(validatedMove) for \(board.whosTurnIsItAnyway )")
                    store.send(.chess(.move(validatedMove)))
                    self.selectedSquare = nil
                   }
               }
    }

    
    
    var body: some View {
        HStack(alignment: .center,spacing:0)
                       {
                        ForEach(ChessFile.allCases)
                           { file in
                               
                               VStack(alignment: .center, spacing:0)
                               {
                                ForEach(ChessRank.allCases.reversed()) { rank in
                                       
                                                   Button(action:{
                                                        print("Send tap action for  \(rank) \(file)")
                                                    self.selectOrMove(to: ChessboardSquare(rank:rank, file:file), board:self.store.value.chessboard )
                                                   } ){
                                                    Spacer().frame(width:self.squareWidth,height: self.squareWidth)
                                                       }
                                                   .frame(width:self.squareWidth, height: self.squareWidth, alignment: .center)
                                       
                                                   }
                                      
                               }
                           }
        }.animation(.easeInOut(duration: 0.2))
    }
}


   
/*
struct TappableCheckersView_Previews: PreviewProvider {
    static var previews: some View {
        TappableCheckersView()
    }
}
*/
