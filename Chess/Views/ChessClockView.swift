//
//  ChessClockView.swift
//  Chess
//
//  Created by David Crooks on 22/12/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

import SwiftUI

struct ChessClockView : View {
    @ObservedObject var store: Store<ChessClockState,ChessClockAction>
   
    var body: some View {
        VStack(spacing:50) {
            ClockView(time:self.store.value.white.remaining)
            ClockView(time:self.store.value.black.remaining)
            Button(action: { self.store.send(.switchPlayer)  } ){
                Text("Swap")
            }
            Button(action: { self.store.send(.start) } ){
                Text("Start")
            }
            Button(action: { self.store.send(.stop) } ){
                Text("Stop")
            }
            
        }
    }
}



struct ClockView : View {
    let time:TimeInterval
    
    func secondsToString(_ time:TimeInterval) -> String {
        let secs  = time.truncatingRemainder(dividingBy:60)
        let totalMins = Int(time)/60
        let hours = totalMins/60
        let mins = totalMins % 60
        
        return String(format: "%02d:%02d:%02.1f", hours, mins  ,secs)
    }

    var body: some View {
        Text( secondsToString(time) )
    }
}

#if DEBUG
/*
struct ChessClockView_Previews: PreviewProvider {
    static var previews: some View {
        ChessClockView(store:ChessClockState(isTiming: false
            black:ClockState(t
            
        ))
    }
}
 */
#endif
