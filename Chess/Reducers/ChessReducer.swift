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
    case noValidMoves
    
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

enum ChessExoAction {
    case clear // move applied
    case move(ChessMove)
    case noValidMoves
    
    var move:ChessAction? {
        guard case let .move(value) = self else { return nil }
                   
        return ChessAction.move(value)
    }
}

func chessReducer(_ board:inout Chessboard,_ action:ChessAction) -> [Effect<ChessExoAction>] {
    switch board.gamePlayState {
    case .inPlay:
        break
    default:
        return []
    }
    
    switch action {
    case .move(let move):
        //print("try move...")
         if let validatedMove = validate(chessboard:board, move:move) {
           // print("     ...move ok")
            print("ChessMove(code:\"\(move)\"),")
            board = apply(move:validatedMove, to: board)
            board.gamePlayState = gamePlayState(chessboard: board)
 
            if(board.whosTurnIsItAnyway == .black) {
                let clearEffect = Effect<ChessExoAction>.sync(work: {
                    return .clear
                })

                let boardCopy = board
                let moveEffect = Effect<ChessExoAction>.sync {
                    if let move = pickMove(for:boardCopy){
                        //print("Sending a move \(move) for  \(board.whosTurnIsItAnyway) for black")
                        return .move(move)
                    }
                    return .noValidMoves
                }
  
                return [clearEffect,moveEffect]
                
            }

        }
         else {
            print(" move fail")
        }
         
    case .offerDraw(_):
        board.gamePlayState = .draw
    case .resign(let player):
        board.gamePlayState = .won(!player)
    case .noValidMoves:
        board.gamePlayState = .draw
    }
    
    return []
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

extension Chessboard {
    mutating func applyTemp(move:ChessMove) {
        var undoState:[ChessboardSquare:ChessPiece?] = [:]
        
        if let pieceToMove = self[move.from] {
            undoState[move.from] = self[move.from]
            undoState[move.to] =  self[move.to]
            self[move.from] = nil;
            
            
            switch move.auxillery {
                
            case .none:
                
                self[move.to] = pieceToMove
                
            case .promote(let kind):
                
                 self[move.to] = ChessPiece(player: pieceToMove.player, kind:kind, id: pieceToMove.id)
                
            case .double(let secondMove):
               
                
                self[move.to] = pieceToMove
                
                if let secondPieceToMove = self[secondMove.from] {
                    undoState[secondMove.from] = self[secondMove.from]
                    undoState[secondMove.to] = self[secondMove.to]
                    self[secondMove.from] = nil;
                    self[secondMove.to] = secondPieceToMove
                }
                
            
            }
            
        }
        
        self.undoStates.append(undoState)
    }
    
    mutating func undoTempMove() {
        let undoState = undoStates.removeLast()
        
        for (square, piece) in undoState {
            self[square] = piece
        }
    }
    
}

