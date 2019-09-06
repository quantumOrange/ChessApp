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
   
    @Binding var board:Chessboard
    @Binding var selectedSquare:ChessboardSquare?
    
    var piece:ChessPiece? {
        self.board[file,rank]
    }
    
    var selected:Bool {
        guard let selectedSq = selectedSquare else { return false }
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
            
            if self.selectedSquare == nil {
                //no square is selected, so we select ourselves.
                self.selectedSquare = self.square
            }
            else if self.selected {
                //we are the selected square, so toggle!
                self.selectedSquare = nil
            } else {
                
                 //We already have a selected "from" square, and so this is a proposed "to" square.
                 // We have everything we need to make a move, provided the propesed move is valid.
                
                if validate(chessboard:self.board, move: ChessMove(from: self.selectedSquare!,to:self.square)) {
                    self.board = move(chessboard: self.board, move: ChessMove(from: self.selectedSquare!,to:self.square))
                    self.selectedSquare = nil
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
        ChessSquareView(board:.constant(Chessboard.start()),selectedSquare:.constant(nil),
                        squareColor: .dark, file: 0, rank: 7,width:100)
    }
}
#endif
