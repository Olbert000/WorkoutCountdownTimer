//
//  SwiftUIView.swift
//  Moonboard Timer
//
//  Created by Kate Riordan on 9/7/2022.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    
    var body: some View {
        let countdownHasCommenced = timerViewModel.countdownHasCommenced
        let countdownTimerHisotryCountPlusOne = timerViewModel.countdownTimerHistory.count+1
        if
            let remainingTime = timerViewModel.remainingTime,
            let currentCountdownExpired = timerViewModel.currentCountdownHasExpired,
            countdownHasCommenced {
            ZStack {
                Text(remainingTime.string(showDeciseconds: true))
                    .withMainTimerStyle(currentCountdownExpired)
                HStack{
                    Text("\(countdownTimerHisotryCountPlusOne)")
                        .withCountStyle()
                    Spacer()
                }
            }
            .padding(5)
            
        }
    }
}

struct MainTimerView_Previews: PreviewProvider {
    static let previewViewModel = TimerViewModel()
    static var previews: some View {
        TimerView().environmentObject(previewViewModel)
    }
}
