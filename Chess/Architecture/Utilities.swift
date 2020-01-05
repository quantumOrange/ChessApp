//
//  Utilities.swift
//  Chess
//
//  Created by David Crooks on 10/11/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

func id<A>(_ a:A)->A {
    a
}

func absurd<A>(_ never:Never) -> A {}

public func with<A, B>(_ a: A, _ f: (A) throws -> B) rethrows -> B {
  return try f(a)
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
