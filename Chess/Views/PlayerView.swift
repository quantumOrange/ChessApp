//
//  PlayerView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI

struct PlayerView : View {
    @State var name:String
    @State var player:PlayerColor
    
    var body: some View {
        HStack(alignment: .center) {
            
            Image(systemName: iconImageName(player))
               .font(.title)
            Text(name)
        }
        
        
    }
    
    var color:Color {
        switch player {
        case .black:
            return Color.black
        case .white:
            return Color.blue
        }
    }
}

func iconImageName(_ player:PlayerColor) -> String {
    switch player {
        
    case .white:
        return "person"
    case .black:
        return "person.fill"
    }
    
}


#if DEBUG
struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(name:"Mr Black", player:.black)
    }
}
#endif
