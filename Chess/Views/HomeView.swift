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
            NavigationLink("Start New Game", destination: ChessGameView(store:store,alertModle:alertModle) )
        }
       
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store:chessStore(),alertModle:AlertModel<GameOverAlertModel>())
    }
}
