//
//  SceneDelegate.swift
//  Chess
//
//  Created by david crooks on 01/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var cancelable:AnyCancellable?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Use a UIHostingController as window root view controller
        
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let store = chessStore()
            /*
            cancelable = store.$value
                                .map{$0.chessboard.whosTurnIsItAnyway}
                                .receive(on:RunLoop.main)
                                .removeDuplicates()
                                .map{
                                    clearSelection(player:$0)
                                    return $0
                                }
                                .delay(for: 1.0, scheduler: RunLoop.main)
                                .sink(receiveValue: { requestMoveIfNeeded(player:$0,store:store)})
            */
            let alertModle = AlertModel<GameOverAlertModel>()
            
            let x = store.$value
                    .map{$0.chessboard.gamePlayState}
                    .receive(on:RunLoop.main)
                    .removeDuplicates()
                    .sink(receiveValue: {
                        switch $0 {
                            
                        case .won(let player):
                            alertModle.value = GameOverAlertModel(state: .win(player), reason: .checkmate)
                            break
                        case .draw:
                            alertModle.value = GameOverAlertModel(state: .draw, reason: .agreement)
                        case .inPlay:
                            break
                        }
                    })
            
            func requestMoveIfNeeded(player:PlayerColor,store:Store<AppState,AppAction>) {
                if(player == .black) {
                    //print( "Player is Black")
                    requestMove(store:store)
                }
                else {
                    //print( "Player is White")
                }
            }
            
            func clearSelection(player:PlayerColor){
                if(player == .black){
                    store.send(.selection(.clear))
                }
            }
            
            func requestMove(store:Store<AppState,AppAction>) {
                let board = store.value.chessboard
                if let move = pickMove(for:board){
                    //print("Sending a move \(move) for  \(board.whosTurnIsItAnyway) for black")
                   store.send(.chess(.move(move)))
                }
            }
            
          //  window.rootViewController = UIHostingController(rootView: ChessGameView(store:store,alertModle:alertModle))
             window.rootViewController = UIHostingController(rootView: HomeView(store:store,alertModle:alertModle))
            self.window = window
            window.makeKeyAndVisible()
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

