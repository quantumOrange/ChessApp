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

class AppState {
    var chessBoard:ChessBoard =  ChessBoard.start()
    var selectedSquare:ChessboardSquare? = nil
}

struct ContentView : View {
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing:50 ){
            PlayerView(name:"Mr Black", player:.black)
           //     .frame(height:50)
           // Spacer(minLength: 10)
                BoardView(board: ChessBoard.start(),width:geometry.size.width)
           // Spacer(minLength: 10)
            PlayerView(name:"Mr White", player:.white)
           //     .frame(height:50)
            
            }
        }
    }
}

func iconImageName(_ player:Player) ->String {
    switch player {
        
    case .white:
        return "person"
    case .black:
        return "person.fill"
    }
    
}

struct PlayerView : View {
    @State var name:String
    @State var player:Player
    
    var body: some View {
        HStack(alignment: .center) {
            
            Image(systemName: iconImageName(player))
               .font(.title)
            Text(name)
        }
       //  .background(self.color)
        
    }
    
    var color:Color {
        switch player {
        case .black:
            return Color.black
        case .white:
            return Color.blue
        }
    }
}


struct BoardView : View {
    @State var board:ChessBoard
    let width:Length
    var body: some View
        {
        //GeometryReader { geometry in
            HStack(alignment: .center,spacing:0)
            {
                ForEach((0..<8)) { i in
                    
                    
                    VStack(alignment: .center, spacing:0)
                    {
                        ForEach((0..<8)) { j in
                            
                            Square(piece:self.board[i,7-j] ,
                                   squareColor: SquareColor.at(file: i, rank: 7-j),width:self.width/8.0)
                            
                        }
                        
                        
                    }
                    
                }
            }
            .frame(width: width, height: width)
        }
    
}

struct Square : View {
    @State var selected:Bool = false
    @State var piece:ChessPiece?
    @State var squareColor:SquareColor
    let width:Length
    var body: some View {
        Button(action:{ self.selected = !self.selected } ){
                if piece != nil {
                    PieceView(piece: piece!, width:width)
                }
            }
            .frame(width:width, height: width, alignment: .center)
            .background(self.selected ? Color.yellow : squareColor.color  )
    }
}

struct PieceView : View {
    @State var piece:ChessPiece
    let width:Length
    var body: some View {
        Text(piece.symbol)
            .font(.largeTitle)
            .frame(width: width, height: width, alignment: .center)
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
#endif


