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
    case match(GKMatch)
    case matchDelegate(MatchDelegate)
    case presentAuthVC(UIViewController)
}

struct GameCenterState {
    var isAuthenticated = false
    var authVC:IndentifiableVC?
    var matchVC:IndentifiableVC?
    var match:GKMatch?
    var matchDelegate:MatchDelegate?
}

class MatchDelegate:NSObject,GKMatchDelegate {
   
    init(send:@escaping (GameCenterAction)->()) {
        self.send = send
    }
    
    var send:(GameCenterAction)->()
    
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

    case .sendMove(let move):
        break
    case .recieveMove(let move):
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
                    print(error)
                }
            })
            
        }
         return [effect]
        
        //let vc = GKTurnBasedMatchmakerViewController(matchRequest: request)
        
        //state.matchVC = IndentifiableVC(id:0, viewController: vc)
        
    case .match(let match):
        state.match = match
        
        
        
        let effect = Effect<GameCenterAction>.async { callback in
            let delegate = MatchDelegate(send:callback)
            callback(.matchDelegate(delegate))
        }
         
        print(match)
        return [effect]
        
       
    case .matchDelegate(let delegate):
        state.match?.delegate = delegate
        state.matchDelegate = delegate
    }
    return []
}
