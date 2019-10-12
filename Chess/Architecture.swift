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

final class Store<Value, Action>: ObservableObject {
  let reducer: (inout Value, Action) -> Void
  @Published private(set) var value: Value

  init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
    self.reducer = reducer
    self.value = initialValue
  }

  func send(_ action: Action) {
    self.reducer(&self.value, action)
  }
    
    var cancelable:Cancellable?

    func wormhole<LocalValue,LocalAction>( focus:@escaping (Value)->LocalValue , lift:@escaping (LocalAction)->Action ) -> Store<LocalValue,LocalAction>
    
    {
        let localStore = Store<LocalValue, LocalAction>(initialValue: focus(value), reducer: { localValue , localAction in            self.send(lift(localAction))
            localValue = focus(self.value)
        })
        
        localStore.cancelable = self.$value.sink{ [weak localStore] newValue in
                localStore?.value = focus(newValue)
        }
        
        return localStore
    }
}

func id<A>(_ a:A)->A {
    a
}

func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
  _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
  value: WritableKeyPath<GlobalValue, LocalValue>,
  action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout GlobalValue, GlobalAction) -> Void {
  return { globalValue, globalAction in
    guard let localAction = globalAction[keyPath: action] else { return }
    reducer(&globalValue[keyPath: value], localAction)
  }
}

infix operator <>

func combineReducers<Value, Action>(
  _ reducers: (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
  return { value, action in
    for reducer in reducers {
      reducer(&value, action)
    }
  }
}



func absurd<A>(_ never:Never) -> A {
    switch never {}
}

public func compose<A, B, C>(
  _ f: @escaping (B) -> C,
  _ g: @escaping (A) -> B
  )
  -> (A) -> C {

    return { (a: A) -> C in
      f(g(a))
    }
}

public func with<A, B>(_ a: A, _ f: (A) throws -> B) rethrows -> B {
  return try f(a)
}

extension Store {
  public func send<LocalValue>(
    _ event: @escaping (LocalValue) -> Action,
    binding keyPath: KeyPath<Value, LocalValue>
  ) -> Binding<LocalValue> {
    return Binding<LocalValue>(get: { self.value[keyPath:keyPath] } , set:{ self.send(event($0)) })
  }
}


