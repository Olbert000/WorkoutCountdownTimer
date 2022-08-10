//
//  TimerButtonsRowView.swift
//  Moonboard Timer
//
//  Created by Oliver Kerr on 23/6/22.
//

import SwiftUI

struct TimerButtonsRowView: View {
    var body: some View {
        let countDownTimes: [TimeInterval] = TimerViewModel.countDownTimes
        let columns = [
            GridItem(.adaptive(minimum: 90))
        ]
        
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(countDownTimes, id: \.self) {countDownTime in
                TimerButtonView(countDownTime: countDownTime)
            }
        }
        .padding(.horizontal)
    }
}
/*
struct TimerButtonsRowView_Previews: PreviewProvider {
    static var previews: some View {
        TimerButtonsRowView(timersModel:TimersModel.exampleTimersModel)
    }
}
*/
