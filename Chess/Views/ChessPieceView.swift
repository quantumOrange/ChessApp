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

class PieceViewModel:ObservableObject,Identifiable {
    var id:Int {
        return piece?.id ?? -square.id
    }
    
    init(piece:ChessPiece?,square:ChessboardSquare){
        self.piece = piece
        self.square = square
    }
    
     @Published var square:ChessboardSquare
     @Published var piece:ChessPiece?
}

struct ChessPieceView : View,Identifiable {
    
    var id: Int {
        vm.id
    }
        
        
    @ObservedObject var vm:PieceViewModel
   
    let width:CGFloat
    
    var backgroundPiece:String {
        guard let piece = vm.piece else { return "" }
        return ChessPiece(player: .black, kind: piece.kind, id:piece.id).symbol
    }
    
    var body: some View {
        ZStack {
            
            Text(verbatim:"\(backgroundPiece)")
                .font(.system(size: width, weight: .thin, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: width, height: width, alignment: .center)
            
            
            Text(verbatim:"\(vm.piece?.symbol  ?? "" )")
                .font(.system(size: width, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
                .frame(width: width, height: width, alignment: .center)
            
            
        }.offset(x: width * CGFloat(vm.square.file.rawValue ), y:  -width * CGFloat(vm.square.rank.rawValue ))
            .animation(.easeInOut(duration: 1.0))
    
        
        
       
    }
}
/*
#if DEBUG
struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack {
                ChessPieceView(piece: ChessPiece(player: .black, kind: .pawn, id:0), width: 60)
                ChessPieceView(piece: ChessPiece(player: .black, kind: .knight, id:0), width: 60)
                ChessPieceView(piece: ChessPiece(player: .black, kind: .bishop, id:0), width: 60)
                ChessPieceView(piece: ChessPiece(player: .black, kind: .rook, id:0), width: 60)
                ChessPieceView(piece: ChessPiece(player: .black, kind: .queen, id:0), width: 60)
                ChessPieceView(piece: ChessPiece(player: .black, kind: .king, id:0), width: 60)
                
            }
            VStack {
                ChessPieceView(piece: ChessPiece(player: .white, kind: .pawn, id:0), width: 60)
                ChessPieceView(piece: ChessPiece(player: .white, kind: .knight, id:0), width: 60)
                ChessPieceView(piece: ChessPiece(player: .white, kind: .bishop, id:0), width: 60)
                ChessPieceView(piece: ChessPiece(player: .white, kind: .rook, id:0), width: 60)
                ChessPieceView(piece: ChessPiece(player: .white, kind: .queen, id:0), width: 60)
                ChessPieceView(piece: ChessPiece(player: .white, kind: .king, id:0), width: 60)
                
            }
            .background(Color.gray)
        }
        
    
    }
}
#endif
*/
