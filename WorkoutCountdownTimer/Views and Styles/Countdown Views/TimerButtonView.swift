//
//  TimerButtonView.swift
//  Moonboard Timer
//
//  Created by Oliver Kerr on 5/6/22.
//

import SwiftUI

struct TimerButtonView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    let countdownTime: TimeInterval
    
    var body: some View {        
        Button() {
            timerViewModel.commenceCountdown(from: countdownTime)
        } label: {
            Text(countdownTime.string(short: true))
                .frame(width: 50)
        }
        .withTimerButtonStyle(color: Color.blue)
    }
}
/*
struct TimerButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TimerButtonView(timersModel:TimersModel.exampleTimersModel, countdownTime: 180)
    }
}
*/
