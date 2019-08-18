//
//  ChessboardView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI

struct ChessboardView : View {
    @Binding var board:Chessboard
    @State var selectedSquare:ChessboardSquare?
    let width:CGFloat
    var body: some View
        {
            HStack(alignment: .center,spacing:0)
            {
                ForEach((0..<8)) { i in
                    
                    
                    VStack(alignment: .center, spacing:0)
                    {
                        ForEach((0..<8)) { j in
                            
                            SquareView(board:self.$board,selectedSquare:self.$selectedSquare,
                                   squareColor: SquareColor.at(file: i, rank: 7-j),file: i, rank: 7-j,width:self.width/8.0)
                            
                        }
                        
                        
                    }
                    
                }
            }
        }
    
}

#if DEBUG
//segmentation fualt!
struct ChessoardView_Previews: PreviewProvider {
    //@State var testboard:Chessboard = Chessboard.start()
    static var previews: some View {
        ChessboardView(board:.constant(Chessboard.start()), width:300)
    }
}
#endif

