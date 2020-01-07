//
//  Delegates.swift
//  Chess
//
//  Created by David Crooks on 06/01/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import Foundation
import GameKit





class TurnBasedMatchmakerDelegate:ActionSender<GameCenterAction>,GKTurnBasedMatchmakerViewControllerDelegate {
  func turnBasedMatchmakerViewControllerWasCancelled(
    _ viewController: GKTurnBasedMatchmakerViewController) {
      viewController.dismiss(animated: true)
  }
  
  func turnBasedMatchmakerViewController(
    _ viewController: GKTurnBasedMatchmakerViewController,
    didFailWithError error: Error) {
      print("Matchmaker vc did fail with error: \(error.localizedDescription).")
  }
}

/*
// I don't think we need this if we are using the GKTurnBasedMatchmakerViewController
 // but might want to come back to this if don;t want to use the viewcontroller.

 class MatchDelegate:ActionSender<GameCenterAction>, GKMatchDelegate {

     func match(_ match: GKMatch, didReceive data: Data, forRecipient recipient: GKPlayer, fromRemotePlayer player: GKPlayer) {
         send(.match(.match(match))
     }
     
     func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer){
         
     }
     
     func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState){
         
     }
     
     func match(_ match: GKMatch, didFailWithError error: Error?){
         
     }

     func match(_ match: GKMatch, shouldReinviteDisconnectedPlayer player: GKPlayer) -> Bool {
         return true;
     }
 }
  
 enum MatchAction {
     case getMatch
     case match(GKMatch)
     case matchDelegate(MatchDelegate)
 }

 func findMatchReducer(state:inout GameCenterState,action:MatchAction) -> [Effect<GameCenterAction>] {
     switch action {
         case .getMatch:
            let request = GKMatchRequest()
            request.maxPlayers = 2
            request.minPlayers = 2
            request.inviteMessage = "Play my fun game"
            print("Get Match")
            
            let effect = Effect<GameCenterAction>.async { callback in
                print("running match effect")
                GKMatchmaker.shared().findMatch(for: request, withCompletionHandler: { match, error in
                    //this is called o the main thread
                    print("match handler")
                    if let match = match {
                     callback(.match(.match(match)))
                    } else {
                         print(error as Any)
                    }
                })
                
            }
             return [effect]
         case .match(let match):
             state.match = match
             
             let effect = Effect<GameCenterAction>.async { callback in
                 let delegate = MatchDelegate(send:callback)
                 callback(.matchDelegate(delegate))
             
                 return [effect]
         case .matchDelegate(let delegate):
             state.match?.delegate = delegate
             state.matchDelegate = delegate
     }
 }
*/
