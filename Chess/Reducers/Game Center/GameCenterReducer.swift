//
//  GameCenterReducer.swift
//  Chess
//
//  Created by David Crooks on 17/11/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation
import GameKit
import SwiftUI
import UIKit
import Combine
import Contacts

enum GameCenterAction {
    case sendMove(ChessMove)
    case recieveMove(ChessMove)
    case activate
    case authenticated
    case getMatch
    case getMatchWithMatchmakerVC
    case match(GKMatch)
    case recievedEvent(GKPlayer,GKTurnBasedMatch,Bool)
    case matchDelegate(MatchDelegate)
    case matchVCDelegate(GKTurnBasedMatchmakerViewControllerDelegate)
    case presentAuthVC(UIViewController)
    case setPlayerListener(GKLocalPlayerListener)
    case quit(GKPlayer,GKTurnBasedMatch)
}

struct GameCenterState {
    var isAuthenticated = false
    var authVC:IndentifiableVC?
    var matchVC:GKTurnBasedMatchmakerViewController?
    var turnBasedMatchmakerDelegate:GKTurnBasedMatchmakerViewControllerDelegate?
    var match:GKMatch?
    var matchDelegate:MatchDelegate?
    var playerListener:GKLocalPlayerListener?
}





struct IndentifiableVC:Identifiable {
    var id: Int
    var viewController:UIViewController
}

struct AnyViewController:UIViewControllerRepresentable {
    
    var viewController:UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        return self.viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AnyViewController>) {
           
    }
}

func gameCenterReducer(_ state:inout GameCenterState,_ action:GameCenterAction) -> [Effect<GameCenterAction>]{
    switch action {

    case .sendMove(_):
        break
    case .recieveMove(_):
        break
    case .activate:
        print("activate")
        
        let effect = Effect<GameCenterAction>.async { callback in
            print("run game center effect")
            GKLocalPlayer.local.authenticateHandler = { gcAuthVC, error in
                if GKLocalPlayer.local.isAuthenticated {
                    print("Authenticated to Game Center!")
                    callback(.authenticated)
                } else if let vc = gcAuthVC {
                    print("try to send present action")
                    callback(.presentAuthVC(vc))
                }
                else {
                    print("Error authentication to GameCenter: " +
                            "\(error?.localizedDescription ?? "none")")
                }
            }
        }
        
        return [effect]
       
    case .authenticated:
        state.isAuthenticated = true
        let effect = Effect<GameCenterAction>.async { callback in
            callback(.setPlayerListener(PlayerListener(send: callback)))
        }
        return [effect]
        
    case .setPlayerListener(let playerListener):
        state.playerListener = playerListener
        let effect = Effect<GameCenterAction>.fireAndForget {
            GKLocalPlayer.local.register(playerListener)
        }
        return [effect]
    case .presentAuthVC(let authVC):
        print("present")
        state.authVC = IndentifiableVC(id:0, viewController: authVC)
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
                    callback(.match(match))
                } else {
                     print(error as Any)
                }
            })
            
        }
         return [effect]
        
     case .getMatchWithMatchmakerVC:
        let request = GKMatchRequest()
        request.maxPlayers = 2
        request.minPlayers = 2
        request.inviteMessage = "Play my fun game"
        print("Get Match WIth VC")
        
        let vc = GKTurnBasedMatchmakerViewController(matchRequest: request)
        state.matchVC  = vc
        //vc.turnBasedMatchmakerDelegate =
        var effect = Effect<GameCenterAction>.async { callback in
            let delegate = TurnBasedMatchmakerDelegate(send:callback)
            callback(.matchVCDelegate(delegate))
        }
        
        effect.vcToPresent = vc
        
        return [effect]
        
        //state.matchVC = IndentifiableVC(id:0, viewController: vc)
        
    case .match(let match):
        state.match = match
        
        let effect = Effect<GameCenterAction>.async { callback in
            let delegate = MatchDelegate(send:callback)
            callback(.matchDelegate(delegate))
        }
         
        print(match)
        return [effect]
        
    case .matchVCDelegate(let delegate):
        //state.match?.delegate = delegate
        state.matchVC?.turnBasedMatchmakerDelegate = delegate
        state.turnBasedMatchmakerDelegate = delegate
        //state.matchDelegate = delegate
    
    case .matchDelegate(let delegate):
        state.match?.delegate = delegate
        state.matchDelegate = delegate
    case .recievedEvent(let player, let match, let didBecomeActive):
        if didBecomeActive {
            if let vc = state.matchVC {
                state.matchVC = nil
                vc.dismiss(animated: true)
            }
        }
    case .quit(let player,let match):
    // 1
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
