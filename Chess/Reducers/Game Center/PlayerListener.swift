//
//  PlayerListener.swift
//  Chess
//
//  Created by David Crooks on 06/01/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import Foundation
import GameKit

enum PlayerListernerAction {
    case playerRceivedTurnEvent(GKPlayer,GKTurnBasedMatch,Bool)
    case playerWantsToQuit(GKPlayer,GKTurnBasedMatch)
    
}

class PlayerListener:ActionSender<PlayerListernerAction> {
   
}

extension PlayerListener:GKLocalPlayerListener {
     /**********GKTurnBasedEventListener******/
    func player(_ player: GKPlayer, wantsToQuitMatch match: GKTurnBasedMatch)
    {
        send(.playerWantsToQuit(player,match))
    }

    func player(_ player: GKPlayer,receivedTurnEventFor match: GKTurnBasedMatch,didBecomeActive: Bool)
    {
        send(.playerRceivedTurnEvent(player, match, didBecomeActive))
    }
    
    func player(_ player:GKPlayer, didRequestMatchWithOtherPlayers: [GKPlayer])
    {
       // Initiates a match from Game Center with the requested players.
    }
    
    func player(_ player:GKPlayer, matchEnded: GKTurnBasedMatch)
    {
        //Called when the match has ended.
    }

    func player(_ player:GKPlayer, receivedExchangeCancellation: GKTurnBasedExchange, for: GKTurnBasedMatch)
    {
        //Called when the exchange is cancelled by the sender.
    }
    
    func player(_ player: GKPlayer, receivedExchangeReplies: [GKTurnBasedExchangeReply], forCompletedExchange: GKTurnBasedExchange, for: GKTurnBasedMatch)
    {
        //Called when the exchange is completed.
    }
    
    func player(_ player:GKPlayer, receivedExchangeRequest: GKTurnBasedExchange, for: GKTurnBasedMatch)
    {
        
    }
}

func playerListenerReducer(state:inout GameCenterState, action:PlayerListernerAction) -> [Effect<GameCenterAction>] {
    switch action {
        case .playerRceivedTurnEvent(let player, let match, let didBecomeActive):
            print("--recieved event---")
            print(player)
            print(match)
            if didBecomeActive
            {
                if let vc = state.matchVC
                {
                    state.matchVC = nil
                    vc.dismiss(animated: true)
                    print("Dismiss becuase did become active")
                }
                state.currentMatch = match
                //NotificationCenter.default.post(name: .presentGame, object: match)??
                
                match.loadMatchData
                {   data, error in
                let model: Chessboard
                //TODO FIX ALL THIS! -> effect
                    if let data = data
                    {
                        do
                        {
                        // 3
                            model = try JSONDecoder().decode(Chessboard.self, from: data)
                        }
                        catch
                        {
                            model = Chessboard.start()
                        }
                    }
                    else
                    {
                        model = Chessboard.start()
                    }
                }
                //state.model = Chessboard.start()
            }
        
            
        
        case .playerWantsToQuit(let player,let match):
         // 1
            print("---playerWantsToQuit---")
            print(player)
            print(match)
            
            let activeOthers = match.participants.filter { other in
               other.status == .active
            }
            
            // 2
              //player.
            match.currentParticipant?.matchOutcome = .lost
              
            activeOthers.forEach { participant in
              participant.matchOutcome = .won
            }
            
            // 3
            match.endMatchInTurn(
              withMatch: match.matchData ?? Data()
            )
    }
    
    return []
}
