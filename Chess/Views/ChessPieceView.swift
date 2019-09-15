//
//  PieceView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI

struct ChessPieceView : View {
   
    let piece:ChessPiece
    let width:CGFloat
    
    var backgroundPiece:ChessPiece {
        return ChessPiece(player: .black, kind: piece.kind)
    }
    
    var body: some View {
        ZStack {
            
            Text(verbatim:"\(backgroundPiece.symbol)")
                .font(.system(size: width, weight: .thin, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: width, height: width, alignment: .center)
            
            Text(verbatim:"\(piece.symbol)")
                .font(.system(size: width, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
                .frame(width: width, height: width, alignment: .center)
            
            
            
            
        }
        
       
    }
}

#if DEBUG
struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack {
                ChessPieceView(piece: ChessPiece(player: .black, kind: .pawn), width: 60)
                ChessPieceView(piece: ChessPiece(player: .black, kind: .knight), width: 60)
                ChessPieceView(piece: ChessPiece(player: .black, kind: .bishop), width: 60)
                ChessPieceView(piece: ChessPiece(player: .black, kind: .rook), width: 60)
                ChessPieceView(piece: ChessPiece(player: .black, kind: .queen), width: 60)
                ChessPieceView(piece: ChessPiece(player: .black, kind: .king), width: 60)
                
            }
            VStack {
                ChessPieceView(piece: ChessPiece(player: .white, kind: .pawn), width: 60)
                ChessPieceView(piece: ChessPiece(player: .white, kind: .knight), width: 60)
                ChessPieceView(piece: ChessPiece(player: .white, kind: .bishop), width: 60)
                ChessPieceView(piece: ChessPiece(player: .white, kind: .rook), width: 60)
                ChessPieceView(piece: ChessPiece(player: .white, kind: .queen), width: 60)
                ChessPieceView(piece: ChessPiece(player: .white, kind: .king), width: 60)
                
            }
            .background(Color.gray)
        }
        
    
    }
}
#endif
