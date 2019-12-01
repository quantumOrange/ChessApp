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

public typealias Reducer<Value, Action, EnviromentAction> = (inout Value, Action) -> [Effect<EnviromentAction>]


func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
  _ reducer: @escaping Reducer<LocalValue, LocalAction, LocalAction> ,
  value: WritableKeyPath<GlobalValue, LocalValue>,
  action: WritableKeyPath<GlobalAction, LocalAction?>
) -> Reducer<GlobalValue, GlobalAction,GlobalAction> {
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

func pullback<LocalValue, GlobalValue, LocalAction,LocalEnviromentAction, GlobalAction>(
  _ reducer: @escaping Reducer<LocalValue, LocalAction, LocalEnviromentAction> ,
  value: WritableKeyPath<GlobalValue, LocalValue>,
  action: WritableKeyPath<GlobalAction, LocalAction?>,
  f:@escaping (LocalEnviromentAction) -> GlobalAction
) -> Reducer<GlobalValue, GlobalAction,GlobalAction> {
  return { globalValue, globalAction in
    guard let localAction = globalAction[keyPath: action] else { return []}
    let localEffects =  reducer(&globalValue[keyPath: value], localAction)
    
    return localEffects.map { localEffect in
        Effect { callback in
            localEffect.run { localEnviromentAction in
                let globalAction = f(localEnviromentAction)
                callback(globalAction)
            }
            
        }
        
    }
  }
}

func combineReducers<Value, Action, EnvironmentAction>(
  _ reducers: Reducer<Value, Action, EnvironmentAction>...
) -> Reducer<Value, Action, EnvironmentAction> {
  return { value, action in
    return reducers.flatMap { $0(&value, action) }
  }
}







