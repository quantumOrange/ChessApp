//
//  AppAction.swift
//  Chess
//
//  Created by David Crooks on 17/11/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

enum AppAction {
    case chess(ChessAction)
    case selection(chessboardAction)
    case gameCenter(GameCenterAction)
    case clock(ChessClockAction)
}


extension AppAction {
    var chess:ChessAction? {
        get {
            guard case let .chess(value) = self else { return nil }
            return value
        }
        set {
            guard case .chess = self, let newValue = newValue else { return }
            self = .chess(newValue)
        }
    }
    
    var selection:chessboardAction? {
        get {
            guard case let .selection(value) = self else { return nil }
            return value
        }
        set {
            guard case .selection = self, let newValue = newValue else { return }
            self = .selection(newValue)
        }
    }
    
    var gameCenter:GameCenterAction? {
        get {
            guard case let .gameCenter(value) = self else { return nil }
            return value
        }
        set {
            guard case .gameCenter = self, let newValue = newValue else { return }
            self = .gameCenter(newValue)
        }
    }
    
    var clock:ChessClockAction? {
        get {
            guard case let .clock(value) = self else { return nil }
            return value
        }
        set {
            guard case .clock = self, let newValue = newValue else { return }
            self = .clock(newValue)
        }
    }
}
