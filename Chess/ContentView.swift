//
//  ContentView.swift
//  Chess
//
//  Created by david crooks on 01/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI
import Combine


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

struct ContentView : View {
    @ObservedObject var game: GameState
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing:50 ){
                PlayerView(name:"Mr Black", player:.black)
                ChessboardView(board: self.$game.chessboard,width:geometry.size.width)
                PlayerView(name:"Mr White", player:.white)
            }
        }
    }
}

func iconImageName(_ player:PlayerColor) ->String {
    switch player {
        
    case .white:
        return "person"
    case .black:
        return "person.fill"
    }
    
}


struct SquareView : View {
   
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
                    PieceView(piece: piece!, width:width)
                }
            }
            .frame(width:width, height: width, alignment: .center)
        .background(
                
                self.selected ? Color.yellow : squareColor.color  )
    }
}

struct PieceView : View {
    @State var piece:ChessPiece
    let width:CGFloat
    var body: some View {
        Text(piece.symbol)
            .font(.largeTitle)
            .frame(width: width, height: width, alignment: .center)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    
    static var previews: some View {
        ContentView(game: GameState())
    }
}
#endif


