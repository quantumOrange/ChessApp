//
//  ChessGameReducer.swift
//  Chess
//
//  Created by david crooks on 08/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

enum ChessUserAction {
    case tapped(ChessboardSquare)
}


enum GamePlayState {
    case won(PlayerColor)
    case draw
  //  case noStarted
  // case abandoned
    case inPlay
}

func chessgameReducer(_ value:inout GameState,_ action:ChessUserAction)  {
    guard case .inPlay = value.gamePlayState else { return }
    switch action {
    case .tapped(let square):
        print("TAPPED \(square)")
        if value.chessboard.whosTurnIsItAnyway == .white {
            
            selectOrMove(to:square , value:&value)
            value.gamePlayState = gamePlayState(chessboard: value.chessboard)
            
            guard case .inPlay = value.gamePlayState else { return }
            
            if value.chessboard.whosTurnIsItAnyway == .black {
                if let blacksMove = ChessEngine.pickMove(for:value.chessboard){
                    print("Apply move \(blacksMove) for black")
                   value.chessboard = apply(move:blacksMove, to: value.chessboard)
                   value.gamePlayState = gamePlayState(chessboard: value.chessboard)
                }
            }
        }
    
        print(value.chessboard)
    }
}

func gamePlayState(chessboard:Chessboard) -> GamePlayState {
    
    let checked = isInCheck(chessboard: chessboard, player:chessboard.whosTurnIsItAnyway)
    
    let currentPlayerCanMove = validMoves(chessboard:chessboard).count > 0
    
    if checked && !currentPlayerCanMove {
        //checkmate!
        return .won(!(chessboard.whosTurnIsItAnyway))
    }
    
    if !checked && !currentPlayerCanMove {
        return .draw
    }
    return .inPlay
}

func selectOrMove(to square:ChessboardSquare ,  value:inout GameState ) {
    guard let selectedSquare = value.selectedSquare else {
               //no square is selected, so we can select the tapped square if it has the right color of piece.
                print("No square is selected")
               if isYourPiece(chessboard:value.chessboard , square: square) {
                 print("Selecting \(square)")
                   value.selectedSquare = square
               }
               
               return
           }
       
           if selectedSquare == square {
               //Tapping the selected square, so toggle off!
               value.selectedSquare = nil
           } else {
               print("We have a selected square and we will apply a move")
                //We already have a selected "from" square, and so this is a proposed "to" square.
                // We have everything we need to make a move, provided the move is valid.
               
               if let validatedMove = validate(chessboard:value.chessboard, move: ChessMove(from: selectedSquare,to:square)) {
                print("Apply validated move \(validatedMove) for \(value.chessboard.whosTurnIsItAnyway )")
                   value.chessboard = apply( move: validatedMove, to:value.chessboard)
                   value.selectedSquare = nil
               }
           }
}

