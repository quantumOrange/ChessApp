//
//  Effect.swift
//  Chess
//
//  Created by David Crooks on 10/11/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation
import Combine

public struct Effect<Output>: Publisher {
  public typealias Failure = Never

  let publisher: AnyPublisher<Output, Failure>

  public func receive<S>(
    subscriber: S
  ) where S: Subscriber, Failure == S.Failure, Output == S.Input {
    self.publisher.receive(subscriber: subscriber)
  }
}

extension Publisher where Failure == Never {
  public func eraseToEffect() -> Effect<Output> {
    return Effect(publisher: self.eraseToAnyPublisher())
  }
}

extension Effect {
  public static func fireAndForget(work: @escaping () -> Void) -> Effect {
    return Deferred { () -> Empty<Output, Never> in
      work()
      return Empty(completeImmediately: true)
    }
    .eraseToEffect()
  }
}

extension Effect
{
  public static func sync(work: @escaping () -> Output) -> Effect
  {
    return Deferred
        {
            Just(work())
        }
        .eraseToEffect()
  }
}


