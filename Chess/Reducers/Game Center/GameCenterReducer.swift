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

enum GameCenterAction
{
    //case sendMove(ChessMove)
    //case recieveMove(ChessMove)
    case activate
    case authenticated
   
    case getMatch

    //case match(MatchAction)
    
    case presentMatchmakerViewController(GKTurnBasedMatchmakerViewControllerDelegate)
    case presentAuthVC(UIViewController)
    
    case setPlayerListener(GKLocalPlayerListener)
    case playerListener(PlayerListernerAction)
    
    case localPlayerFinishedTurn( Chessboard )
    case remotePlayerFinishedTurn
    
    case completedSendingTurn(Error?)
}

struct GameCenterState
{
    var isAuthenticated = false
    var authVC:IndentifiableVC?
    var matchVC:GKTurnBasedMatchmakerViewController?
    var turnBasedMatchmakerDelegate:GKTurnBasedMatchmakerViewControllerDelegate?
    var currentMatch:GKTurnBasedMatch?
    //var matchDelegate:MatchDelegate?
    var playerListener:GKLocalPlayerListener?
    
    var isSendingTurn = false
    
    var model:Chessboard? = nil 
}

struct IndentifiableVC:Identifiable
{
    var id: Int
    var viewController:UIViewController
}

struct AnyViewController:UIViewControllerRepresentable
{
    
    var viewController:UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController
    {
        return self.viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AnyViewController>)
    {
           
    }
}

func gameCenterReducer(_ state:inout GameCenterState,_ action:GameCenterAction) -> [Effect<GameCenterAction>]
{
    switch action
    {
    case .localPlayerFinishedTurn( let chessboard ):
        state.isSendingTurn = true
        guard let match = state.currentMatch else
        {
          //completion(GameCenterHelperError.matchNotFound)
          return []
        }
        
        let effect = Effect<GameCenterAction>.async
        {   callback in
            do
            {
                match.message = "message-To-Display"

                // 2
                match.endTurn(
                withNextParticipants: match.participants,
                turnTimeout: GKExchangeTimeoutDefault,
                match: try JSONEncoder().encode(chessboard),
                completionHandler:  {   error in
                                        callback(.completedSendingTurn(error))
                                    }
                )
            }
            catch
            {
              callback(.completedSendingTurn(error))
            }
        }
        
        return [effect]

        
    case .completedSendingTurn(let error):
        if let error = error
        {
            print(error)
        }
        state.isSendingTurn = false
    case .remotePlayerFinishedTurn:
        break
    case .activate:
        print("activate")
        
        let effect = Effect<GameCenterAction>.async
        {   callback in
            
            print("run game center effect")
            GKLocalPlayer.local.authenticateHandler =
            {   gcAuthVC, error in
                
                if GKLocalPlayer.local.isAuthenticated
                {
                    print("Authenticated to Game Center!")
                    callback(.authenticated)
                }
                else if let vc = gcAuthVC
                {
                    print("try to send present action")
                    callback(.presentAuthVC(vc))
                }
                else
                {
                    print("Error authentication to GameCenter: " +
                            "\(error?.localizedDescription ?? "none")")
                }
            }
        }
        
        return [effect]
       
    case .authenticated:
        state.isAuthenticated = true
        let effect = Effect<GameCenterAction>.async
        {   callback in
            let sendAction =
            {   action in
                callback(.playerListener(action))
            }
            callback(.setPlayerListener(PlayerListener(send: sendAction)))
        }
        return [effect]
        
    case .setPlayerListener(let playerListener):
        state.playerListener = playerListener
        let effect = Effect<GameCenterAction>.fireAndForget
        {
            GKLocalPlayer.local.register(playerListener)
        }
        
        return [effect]
        
    case .presentAuthVC(let authVC):
        print("present")
        state.authVC = IndentifiableVC(id:0, viewController: authVC)
        
     case .getMatch:
        
        print("Get Match WIth VC")
        
        //vc.turnBasedMatchmakerDelegate =
        let matchMakerDelegateEffect = Effect<GameCenterAction>.async
        {   callback in
            let delegate = TurnBasedMatchmakerDelegate(send:callback)
            callback(.presentMatchmakerViewController(delegate))
        }
        
        //effect.vcToPresent = vc
        
        return [matchMakerDelegateEffect]
        
    case .presentMatchmakerViewController(let delegate):
        let request = GKMatchRequest()
        request.maxPlayers = 2
        request.minPlayers = 2
        request.inviteMessage = "Play my fun game"
        
        let matchmakerViewController = GKTurnBasedMatchmakerViewController(matchRequest: request)
        matchmakerViewController.turnBasedMatchmakerDelegate = delegate
        state.matchVC  = matchmakerViewController
        //state.match?.delegate = delegate
        
        state.turnBasedMatchmakerDelegate = delegate
        
        let effect = Effect<GameCenterAction>.present(matchmakerViewController)
        
        return [effect]
    
    case .playerListener(let action):
        return playerListenerReducer(state: &state, action: action)
    
    }
    return []
}
