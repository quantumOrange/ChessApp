//
//  Architecture.swift
//  Chess
//
//  Created by david crooks on 08/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

import Combine
import SwiftUI

public typealias Reducer<Value, Action> = (inout Value, Action) -> [Effect<Action>]

func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
  _ reducer: @escaping Reducer<LocalValue, LocalAction> ,
  value: WritableKeyPath<GlobalValue, LocalValue>,
  action: WritableKeyPath<GlobalAction, LocalAction?>
) -> Reducer<GlobalValue, GlobalAction> {
  return { globalValue, globalAction in
    guard let localAction = globalAction[keyPath: action] else { return []}
    let localEffects =  reducer(&globalValue[keyPath: value], localAction)
    
    return localEffects.map { localEffect in
        Effect { callback in
            localEffect.run { localAction in 
                var globalAction = globalAction
                globalAction[keyPath: action] = localAction
                callback(globalAction)
            }
            
        }
        
    }
  }
}

//infix operator <>

func combineReducers<Value, Action>(
  _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
  return { value, action in
    return reducers.flatMap { $0(&value, action) }
  }
}







