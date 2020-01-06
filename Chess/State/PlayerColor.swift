//
//  PlayerColor.swift
//  Chess
//
//  Created by David Crooks on 06/01/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import Foundation

enum PlayerColor:String,Equatable,Codable {
    case white
    case black
}

prefix func !(v:PlayerColor)-> PlayerColor {
    switch v {
    case .white:
        return .black
    case .black:
        return .white
    }
}
