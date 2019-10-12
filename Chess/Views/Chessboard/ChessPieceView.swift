//
//  PieceView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI

extension ChessboardSquare:Identifiable {
    var id: Int {
        (self.file.rawValue * 8 + self.rank.rawValue)
    }
}

struct PieceViewModel:Identifiable {
    var id:Int {
        return piece?.id ?? -square.id
    }
    
    init(piece:ChessPiece?, square:ChessboardSquare, pointOfView:PlayerColor){
        self.piece = piece
        self.square = square
        self.pointOfView = pointOfView
    }
    
    var pointOfView:PlayerColor
    var square:ChessboardSquare
    var piece:ChessPiece?
    
    var offsetX:CGFloat {
        switch pointOfView {
        case .white:
            return CGFloat(square.file.rawValue)
        case .black:
            return CGFloat(7 - square.file.rawValue)
        }
        
    }
    
    var offsetY:CGFloat {
       switch pointOfView {
       case .white:
            return CGFloat(-square.rank.rawValue)
       case .black:
            return CGFloat(square.rank.rawValue - 7)
       }
      
    }
}

struct ChessPieceView : View {
    /*
    var id: Int {
        vm.id
    }
        
    */
    //@ObservedObject var store:Store<PieceViewModel,Never>
    @ObservedObject var store:ObservedViewModel<PieceViewModel>
    let width:CGFloat
    
    var backgroundPiece:String {
        guard let piece = store.value.piece else { return "" }
        return ChessPiece(player:.black, kind: piece.kind, id:piece.id).symbol
    }
    
    var body: some View {
        ZStack {
            
            Text(verbatim:"\(backgroundPiece)")
                .font(.system(size: width, weight: .thin, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: width, height: width, alignment: .center)
            
            
            Text(verbatim:"\(store.value.piece?.symbol  ?? "" )")
                .font(.system(size: width, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
                .frame(width: width, height: width, alignment: .center)
            
            
        }.offset(x: width * store.value.offsetX , y:  width * store.value.offsetY )
            .animation(.easeInOut(duration: 1.0))
    
        
        
       
    }
}
