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
    
    static func at(file:Int,rank:Int) -> SquareColor {
        return (rank + file).isMultiple(of: 2) ?
                                            .dark :
                                            .light
    }
}

extension SquareColor {
    var color:Color {
        switch self {
        case .dark:
            return Color.gray
        case .light:
            return Color.white
        }
    }
}

struct ChessSquareView : View {
   
    @ObservedObject var store: Store<GameState,ChessUserAction>
    
    
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
    
    
    var sqColor:Color {
        guard let color = squareColor?.color else { return Color.clear }
        let destSqs = store.value.possibleDestinationSquares
        
        
        let highlighted = self.selected || destSqs.contains(square)
        
        
       return  highlighted ? Color.yellow : color
        
        
    }
    
    let squareColor:SquareColor?
    let file:Int
    let rank:Int
    
    let width:CGFloat
    var body: some View {
        Button(action:{
            self.store.send(.tapped(self.square))
        } ){
            Spacer().frame(width:width,height: width)
            }
            .frame(width:width, height: width, alignment: .center)
        .background(sqColor)
    }
}

#if DEBUG
struct ChessSquareView_Previews: PreviewProvider {
    static var previews: some View {
        ChessSquareView(store:chessStore(),
                        squareColor: .dark, file: 0, rank: 7,width:100)
    }
}
#endif
