//
//  ChessMoveReducer.swift
//  Chess
//
//  Created by david crooks on 08/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

enum ChessAction {
    case move(ChessMove)
    case resign(PlayerColor)
    case offerDraw(PlayerColor)
    
    var move:ChessMove? {
        guard case let .move(mv) = self else { return nil }
        return mv
    }
    
    var resign:PlayerColor? {
        guard case let .resign(player) = self else { return nil }
        return player
    }
    
    var offerDraw:PlayerColor? {
        guard case let .offerDraw(player) = self else { return nil }
        return player
    }
}

func chessReducer(_ board:inout Chessboard,_ action:ChessAction)  {
    switch action {
    case .move(let move):
        print("try move...")
         if let validatedMove = validate(chessboard:board, move:move) {
            print("     ...move ok")
            print(move)
            board = apply(move:validatedMove, to: board)
            print(board)
        }
         else {
            print(" move fail")
        }
        
    case .offerDraw(let player):
        break
    case .resign(let player):
        break
    }
}

func apply(move:ChessMove, to board:Chessboard) -> Chessboard {
    var board = board
    
    if let pieceToMove = board[move.from] {
        board[move.from] = nil;
        
        
        switch move.auxillery {
            
        case .none:
           
            board[move.to] = pieceToMove
            
        case .promote(let kind):
            
             board[move.to] = ChessPiece(player: pieceToMove.player, kind:kind, id: pieceToMove.id)
            
        case .double(let secondMove):
           

            board[move.to] = pieceToMove
            
            if let secondPieceToMove = board[secondMove.from] {
              
                board[secondMove.from] = nil;
                board[secondMove.to] = secondPieceToMove
            }
            
        
        }
        
    }
    
    board.moves.append(move)
    //board.playState = playState(chessboard:board)
    
    return board
}



