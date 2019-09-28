//
//  ChessboardSquaresView.swift
//  Chess
//
//  Created by david crooks on 22/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI

enum SquareColor {
    case dark
    case light
    
    static func at(rank:ChessRank,file:ChessFile) -> SquareColor {
        return (rank.rawValue + file.rawValue).isMultiple(of: 2) ?
                                            .dark :
                                            .light
    }
}

extension SquareColor {
    
    var color:Color {
        switch self {
        case .dark:
            return Color(hue: 240.0/360.0, saturation:0.25, brightness: 0.75)
        case .light:
            return Color.white
        }
    }
    
    var highlightedColor:Color {
        switch self {
        case .dark:
            return Color(hue: 60.0/360.0, saturation:0.75, brightness: 0.85)
        case .light:
            return Color(hue: 60.0/360.0, saturation:0.5, brightness: 1.0)
        }
    }
    
}

struct ChessboardSquaresView: View {
    
    @ObservedObject var store: Store<GameState,ChessUserAction>
         
    let width:CGFloat
    
    var squareWidth:CGFloat {
        width/8.0
    }
    
    func color(rank:ChessRank,file:ChessFile) -> Color {
        let sqColor = SquareColor.at(rank:rank, file: file)
        
        let square = ChessboardSquare(rank:rank, file:file)
        
        let couldMoveToSquare = store.value.possibleDestinationSquares.contains(square)
        
        let selected = store.value.selectedSquare == square
        
        let highlighted = selected || couldMoveToSquare
        
        return highlighted ? sqColor.highlightedColor : sqColor.color
    }
    
    var body: some View {
        HStack(alignment: .center,spacing:0)
                       {
                           ForEach((ChessFile.allCases))
                           { file in
                               
                               
                               VStack(alignment: .center, spacing:0)
                               {
                                ForEach((ChessRank.allCases.reversed())) { rank in
                                     
                                   Spacer()
                                    .frame(width:self.squareWidth,height:self.squareWidth)
                                    .background(self.color(rank: rank, file: file))
                                }
                               }
                               
                           }
                       }.animation(.easeInOut(duration: 2.0))
    }
}


