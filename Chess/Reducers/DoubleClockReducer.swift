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

enum ChessClockExoAction {
    case update(TimeInterval)
    case outOfTime(PlayerColor)
}

struct ChessClockState {
    init(time:TimeInterval) {
        self.black = ClockState(total:time,remaining:time)
        self.white = ClockState(total:time,remaining:time)
    }
    
    var isTiming:Bool = false
    var black:ClockState
    var white:ClockState
    var activePlayer:PlayerColor = .white
}

struct ClockState {
    
    let total:TimeInterval
    let remaining:TimeInterval
    
    var outOfTime:Bool {
        remaining <= 0
    }
    
    func less(time:TimeInterval) -> ClockState {
        let newTime = Double.maximum(remaining - time,0.0)
        return ClockState(total:total,remaining: newTime)
    }
}

func feedback<A>(_ action:A) -> Effect<A> {
    return  Effect<A>.async { callback in
        callback(action)
    }
}

func chessClockReducer(_ state:inout  ChessClockState,_ action:ChessClockAction) -> [Effect<ChessClockExoAction>]{
    let defaultDelay = 0.1
    
    switch action {

    case .update(let deltaTime):
        if state.isTiming {
            switch state.activePlayer {
            case .white:
                state.white = state.white.less(time: deltaTime)
                if state.white.outOfTime {
                    state.isTiming = false
                    return [Effect.send(.outOfTime(.white))]
                }
            case .black:
                state.black = state.black.less(time: deltaTime)
                if state.black.outOfTime {
                    state.isTiming = false
                    return [Effect.send(.outOfTime(.black))] //stop the game here!
                }
            }
            return [update(delay:defaultDelay)]
        }
        print("---update---")
        print(state)
    case .reset(let time):
        print("---reset---")
        state.black = ClockState(total:time,remaining:time)
        state.white = ClockState(total:time,remaining:time)
        state.activePlayer = .white
    case .switchPlayer:
        print("---switch---")
        state.activePlayer = !state.activePlayer
        //let effect = feedback(.update)
    case .stop:
        print("---stop---")
        state.isTiming = false
    case .start:
        print("---start--")
        state.isTiming = true
        return [update(delay:defaultDelay)]
    }
    return []
}

func update(delay:TimeInterval)-> Effect<ChessClockExoAction> {
 
    return Effect<ChessClockExoAction>.async { callback in
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            callback(.update(delay))
        })
        
    }
    
}
