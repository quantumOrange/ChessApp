//
//  Enviroment.swift
//  Chess
//
//  Created by David Crooks on 02/10/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation
import Combine
import SwiftUI


struct GameOverAlertModel:Identifiable {
    var id:Int {
        switch self.state {
        case .win(let player):
            switch player {
            case .black:
               return 0
            case .white:
                return 1
                
            }
        case .draw:
            return 2
        }
    }
    
    var state:State
    var reason:Reason
    
    enum State {
        case win(PlayerColor)
        case draw
    }
    
    enum Reason:String {
        case resignation
        case checkmate
        case timeout
        case abandonment
        case agreement
        case repetion
    }
    
    var text:String {
        switch self.state {
            
        case .win(let player):
            return "\(player) wins by \(self.reason)"
        case .draw:
            return "The game was a draw"
       
        }
    }
}
/*
final class AlertModel<Value>: ObservableObject {
    @Published var value: Value? = nil
}
*/

