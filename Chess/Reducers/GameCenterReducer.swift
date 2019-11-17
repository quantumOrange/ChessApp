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
    case match
    case present(UIViewController)
}

struct GameCenterState {
    var authVC:IndentifiableVC?
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
                    } else if let vc = gcAuthVC {
                        print("try to send present action")
                        callback(.present(vc))
                    }
                    else {
                        print("Error authentication to GameCenter: " +
                                "\(error?.localizedDescription ?? "none")")
                    }
                }
            }
        return [effect]
    case .present(let authVC):
        print("present")
        state.authVC = IndentifiableVC(id: 0, viewController: authVC)
    case .match:
        break
    }
    return []
}
