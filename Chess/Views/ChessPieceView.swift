//
//  PieceView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI

struct ChessPieceView : View {
    @State var piece:ChessPiece // should be a binding
    let width:CGFloat
    var body: some View {
        Text(piece.symbol)
            .font(.largeTitle) //should scale
            .frame(width: width, height: width, alignment: .center)
    }
}

#if DEBUG
struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        ChessPieceView(piece: ChessPiece(player: .black, kind: .knight), width: 300)
    }
}
#endif
