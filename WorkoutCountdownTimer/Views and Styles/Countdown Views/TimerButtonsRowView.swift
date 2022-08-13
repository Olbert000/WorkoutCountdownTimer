//
//  TimerButtonsRowView.swift
//  Moonboard Timer
//
//  Created by Oliver Kerr on 23/6/22.
//

import SwiftUI

struct TimerButtonsRowView: View {
    var body: some View {
        let countdownTimes: [TimeInterval] = TimerViewModel.countdownTimes
        let columns = [
            GridItem(.adaptive(minimum: 90))
        ]
        
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(countdownTimes, id: \.self) {countdownTime in
                TimerButtonView(countdownTime: countdownTime)
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
