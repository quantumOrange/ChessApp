//
//  HomeView.swift
//  Chess
//
//  Created by David Crooks on 07/11/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI

func focusClockState(appState:AppState) -> ChessClockState {
    return appState.clocks
}

func liftClockAction(clockAction:ChessClockAction) -> AppAction {
    return .clock(clockAction)
}
 
struct HomeView: View {
    
    @ObservedObject var store: Store<AppState,AppAction>
   // @ObservedObject var alertModle:AlertModel<GameOverAlertModel>
    
    var body: some View {
        NavigationView {
            VStack(spacing:50) {
                NavigationLink("Play Computer", destination: ChessGameView(store:store ))
                NavigationLink("Show clock", destination: ChessClockView(store:self.store.wormhole(focus:{ $0.clocks }, lift: { .clock($0)})) )
                                
                Button(action: {self.store.send(.gameCenter(.activate))  }){
                    Text("Authenticate with Game Center")
                }
                
                Button(action: {self.store.send(.gameCenter(.getMatchWithMatchmakerVC))  }){
                    Text("Get Match")
                }
                
                //PresentationButton(destination: EmptyView()) { Text("Login") }
            }.sheet(item: .constant(self.store.value.gameCenter.authVC)) { authVC in
                AnyViewController(viewController: authVC.viewController)
            }
        }
       
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store:chessStore())
    }
}
