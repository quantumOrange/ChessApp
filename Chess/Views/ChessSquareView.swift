//
//  ChessSquareView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI

enum SquareColor {
    case dark
    case light
    
    var color:Color {
        switch self {
        case .dark:
            return Color.gray
        case .light:
            return Color.white
        }
    }
    
    static func at(file:Int,rank:Int) -> SquareColor {
        return (rank + file).isMultiple(of: 2) ?
                                            .dark :
                                            .light
    }
}

struct ChessSquareView : View {
   
    @ObservedObject var store: Store<GameState,ChessGameAction>
    //@Binding var selectedSquare:ChessboardSquare?
    
    var piece:ChessPiece? {
        store.value.chessboard[file,rank]
    }
    
    var selected:Bool {
        guard let selectedSq = store.value.selectedSquare else { return false }
        return selectedSq == square
    }
 
    var square:ChessboardSquare {
        ChessboardSquare(rank: ChessRank(rawValue: rank)!, file: ChessFile(rawValue: file)!)
    }
    
    let squareColor:SquareColor
    let file:Int
    let rank:Int
    
    let width:CGFloat
    var body: some View {
        Button(action:{
            
            if self.store.value.selectedSquare == nil {
                //no square is selected, so we select ourselves.
                self.store.value.selectedSquare = self.square
            }
            else if self.selected {
                //we are the selected square, so toggle!
                self.store.value.selectedSquare = nil
            } else {
                
                 //We already have a selected "from" square, and so this is a proposed "to" square.
                 // We have everything we need to make a move, provided the propesed move is valid.
                
                if validate(chessboard:self.store.value.chessboard, move: ChessMove(from: self.store.value.selectedSquare!,to:self.square)) {
                    self.store.value.chessboard = move(chessboard: self.store.value.chessboard, move: ChessMove(from: self.store.value.selectedSquare!,to:self.square))
                    self.store.value.selectedSquare = nil
                }
            }
            
        } ){
                if piece != nil {
                    ChessPieceView(piece: piece!, width:width)
                }
            }
            .frame(width:width, height: width, alignment: .center)
        .background(
                
                self.selected ? Color.yellow : squareColor.color  )
    }
}

#if DEBUG
struct ChessSquareView_Previews: PreviewProvider {
    static var previews: some View {
        ChessSquareView(store:Store<Any,Any>.chessStore(),
                        squareColor: .dark, file: 0, rank: 7,width:100)
    }
}
#endif
