//
//  ContentView.swift
//  Chess
//
//  Created by david crooks on 01/08/2019.
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

struct ContentView : View {
   // @State var chessBoard: ChessBoard
    
    var body: some View {
        BoardView(board: ChessBoard.start())
    }
}

struct BoardView : View {
    @State var board:ChessBoard
    
    var body: some View {
        
        HStack(alignment: .center,spacing:0){
            ForEach((0..<8)) { i in
               
 
                VStack(alignment: .center, spacing:0){
                    ForEach((0..<8)) { j in
                      
                        
                         Square(piece:self.board[i,7-j] ,
                                squareColor: SquareColor.at(file: i, rank: 7-j))
                        
                    }
                    
                    
                }

            }
        }

    }
}

struct Square : View {
    @State var piece:ChessPiece?
    @State var squareColor:SquareColor
    var body: some View {
        ZStack(){

            Spacer()
                .frame(width: 50, height: 50, alignment: .center)
                .background(squareColor.color)
            
            if piece != nil {
                PieceView(piece: piece!)
            }
            
        }
            .frame(width: 50, height: 50, alignment: .center)
            
    }
}

struct PieceView : View {
    @State var piece:ChessPiece
    
    var body: some View {
        Text(piece.symbol)
            .font(.largeTitle)
            .frame(width: 50, height: 50, alignment: .center)
        
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
#endif
