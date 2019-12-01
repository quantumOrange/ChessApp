//
//  HomeView.swift
//  Chess
//
//  Created by David Crooks on 07/11/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var store: Store<AppState,AppAction>
    @ObservedObject var alertModle:AlertModel<GameOverAlertModel>
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("Play Computer", destination: ChessGameView(store:store,alertModle:alertModle) )
                Button(action: {self.store.send(.gameCenter(.activate))  }){
                    Text("Authenticate with Game Center")
                }
                Button(action: {self.store.send(.gameCenter(.getMatch))  }){
                    Text("Match")
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
        HomeView(store:chessStore(),alertModle:AlertModel<GameOverAlertModel>())
    }
}
