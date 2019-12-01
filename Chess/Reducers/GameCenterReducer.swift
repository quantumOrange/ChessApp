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

enum GameCenterAction {
    case sendMove(ChessMove)
    case recieveMove(ChessMove)
    case activate
    case authenticated
    case getMatch
    case match(GKMatch)
    case presentAuthVC(UIViewController)
}

struct GameCenterState {
    var isAuthenticated = false
    var authVC:IndentifiableVC?
    var matchVC:IndentifiableVC?
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
        let effect =  Effect<GameCenterAction> { callback in
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
        let effect = Effect<GameCenterAction> { callback in
            print("running match effect")
            GKMatchmaker.shared().findMatch(for: request, withCompletionHandler: { match, error in
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
        print(match)
        
    }
    return []
}
