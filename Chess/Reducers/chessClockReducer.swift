//
//  chessClockReducer.swift
//  Chess
//
//  Created by David Crooks on 01/12/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

enum ChessClockAction {
    case update(TimeInterval)
    case reset(TimeInterval)
    case switchPlayer
    case stop
    case start
}

struct ChessClockState {
    var isTiming:Bool
    var black:ClockState
    var white:ClockState
    var activePlayer:PlayerColor = .white
}

struct ClockState {
    let total:TimeInterval
    let remaining:TimeInterval
    
    func less(time:TimeInterval) -> ClockState {
        let newTime = remaining - time
        return ClockState(total:total,remaining: newTime)
    }
}

func feedback<A>(_ action:A) -> Effect<A> {
    return  Effect<A>.async { callback in
        callback(action)
    }
}

func chessClockReducer(_ state:inout  ChessClockState,_ action:ChessClockAction) -> [Effect<ChessClockAction>]{
    switch action {

    case .update(let deltaTime):
        if state.isTiming {
            switch state.activePlayer {
            case .white:
                state.white = state.white.less(time: deltaTime)
            case .black:
                state.black = state.black.less(time: deltaTime)
            }
            return [update(delay:0.1)]
        }
    case .reset(let time):
        state.black = ClockState(total:time,remaining:time)
        state.white = ClockState(total:time,remaining:time)
        state.activePlayer = .white
    case .switchPlayer:
        state.activePlayer = !state.activePlayer
        //let effect = feedback(.update)
    case .stop:
        state.isTiming = false
    case .start:
        state.isTiming = true
        return [update(delay:0.1)]
    }
    return []
}

func update(delay:TimeInterval)-> Effect<ChessClockAction> {
    return Effect<ChessClockAction>.async { callback in
        //delay!
        callback(.update(delay))
    }
}
