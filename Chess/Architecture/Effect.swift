//
//  Effect.swift
//  Chess
//
//  Created by David Crooks on 10/11/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//
import UIKit
import Foundation
import Combine

//public struct Effect<Output,ExoAction>


public struct Effect<Output>: Publisher {
  public typealias Failure = Never

  let publisher: AnyPublisher<Output, Failure>

  public func receive<S>(
    subscriber: S
  ) where S: Subscriber, Failure == S.Failure, Output == S.Input {
    self.publisher.receive(subscriber: subscriber)
  }

var vcToPresent:UIViewController? = nil
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

extension Effect {
    public static func present(viewController vc:UIViewController) -> Effect {
        var effect = Deferred { () -> Empty<Output, Never> in
          
          return Empty(completeImmediately: true)
        }
        .eraseToEffect()
        
        effect.vcToPresent = vc
        return effect
  }
}

extension Effect
{
    public static func send(_ action:Output) -> Effect {
        return sync(work: { action })
    }
}



extension Effect
{
    
  public static func sync(work: @escaping () -> Output) -> Effect
  {
    return Deferred
        {
           return  Just(work())
        }
        .eraseToEffect()
  }

  public static func async(work: @escaping (@escaping  (Output) ->()) -> ()) -> Effect
  {
    return Deferred
        {
            Future<Output,Never> { promise in
                work { output in
                    promise(.success(output))
                }
            }
        }
        .eraseToEffect()
  }
}




