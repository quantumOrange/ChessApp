//
//  Delegates.swift
//  Chess
//
//  Created by David Crooks on 06/01/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import Foundation
import GameKit
//I don't think we need this if we are just going to use the GKTurnBasedMatchmakerViewController
class MatchDelegate:ActionSender, GKMatchDelegate {

    func match(_ match: GKMatch, didReceive data: Data, forRecipient recipient: GKPlayer, fromRemotePlayer player: GKPlayer) {
        send(.match(match))
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

class TurnBasedMatchmakerDelegate:ActionSender,GKTurnBasedMatchmakerViewControllerDelegate {
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

class PlayerListener:ActionSender, GKLocalPlayerListener {
    func player(_ player: GKPlayer, wantsToQuitMatch match: GKTurnBasedMatch) {
      send(.quit(player,match))
      
    }
    
    func player(
              _ player: GKPlayer,
              receivedTurnEventFor match: GKTurnBasedMatch,
              didBecomeActive: Bool
            )
    {
        send(.recievedEvent(player, match, didBecomeActive))
        //NotificationCenter.default.post(name: .presentGame, object: match)
    }
    
}
