//
//  ChessPiecesOnBoardView.swift
//  Chess
//
//  Created by david crooks on 22/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI


func liftOptional<A,B>(_ optTuple:( A?,B )) -> (A,B)? {
    guard let a = optTuple.0 else {return nil}
    return (a,optTuple.1)
}

extension Chessboard {
    var pieceSquarePairs:[( ChessPiece,ChessboardSquare )] {
        squares.compactMap{ liftOptional(( self[$0], $0))}
    }
    
    var pieceVMS:[PieceViewModel] {
            pieceSquarePairs
                .map{ PieceViewModel(piece: $0.0, square: $0.1) }
    }
    
    func pieceVM(rank:Int,file:Int) -> PieceViewModel {
        let sq =  ChessboardSquare(rank: ChessRank(rawValue: rank)!, file: ChessFile(rawValue: file)!)
        let piece = self[sq]
        return PieceViewModel(piece: piece, square: sq)
    }
}

struct ChessPiecesOnBoardView: View {
    @ObservedObject var store: Store<AppState,Never>
    
    let width:CGFloat
    
    var body: some View {
        VStack{
             Spacer().frame(width: self.width/8.0, height:7*self.width/8.0, alignment: .center)
             HStack(alignment: .bottom, spacing: 0) {
                ZStack
                {
                    ForEach(store.value.chessboard.pieceVMS){ viewModel in
                        ChessPieceView(vm:viewModel, width: self.width/8.0)
                    }
                }
                Spacer().frame(width: 7*self.width/8.0, height: self.width/8.0, alignment: .center)
            }
           
        }
        
    }
}

