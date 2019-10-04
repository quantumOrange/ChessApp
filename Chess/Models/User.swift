//
//  User.swift
//  Chess
//
//  Created by david crooks on 11/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation


struct User {
    let id:Int
    let name:String
    let rating:Float
}

extension User {
    static func david() -> User {
        User(id: 1, name: "David", rating: 1200)
    }
    static func chewbacka() -> User {
         User(id: 2, name: "Chewbacka", rating: 1390)
    }
}

enum PlayerType {
    case appUser
    case remote(User)
    case computer
}

struct Players {
    let white:User
    let black:User
    
    func player(for color:PlayerColor) -> User {
        switch color {
        case .white:
            return white
        case .black:
            return black
        }
    }
}

extension Players {
    static func dummys()-> Players {
        Players(white: User.david(), black: User.chewbacka())
    }
}

func getUsers(callback:([User]) -> ()) {
    
    let users = [
        User(id: 321, name: "Jimbob", rating: 1200),
        User(id: 32, name: "Han Solo", rating: 1345),
        User(id: 78, name: "R2D2", rating: 1456),
        User(id: 2, name: "Chewbacka", rating: 890),
        User(id: 46, name: "Helmut", rating: 678),
        User(id: 103, name: "Tracy", rating: 1109)
    ]
    
    callback(users)
}



