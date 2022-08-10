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
        let countDownHasCommenced = timerViewModel.countDownHasCommenced
        let countDownTimerHisotryCountPlusOne = timerViewModel.countDownTimerHistory.count+1
        if
            let remainingTime = timerViewModel.remainingTime,
            let currentCountDownExpired = timerViewModel.currentCountDownHasExpired,
            countDownHasCommenced {
            ZStack {
                Text(remainingTime.string(showDeciseconds: true))
                    .withMainTimerStyle(currentCountDownExpired)
                HStack{
                    Text("\(countDownTimerHisotryCountPlusOne)")
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
