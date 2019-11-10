//
//  Store.swift
//  Chess
//
//  Created by David Crooks on 10/11/2019.
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

extension Store {
  public func send<LocalValue>(
    _ event: @escaping (LocalValue) -> Action,
    binding keyPath: KeyPath<Value, LocalValue>
  ) -> Binding<LocalValue> {
    return Binding<LocalValue>(get: { self.value[keyPath:keyPath] } , set:{ self.send(event($0)) })
  }
}

