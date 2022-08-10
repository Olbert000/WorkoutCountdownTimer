//
//  ControlButtonsView.swift
//  Moonboard Timer
//
//  Created by Oliver Kerr on 23/6/22.
//

import SwiftUI

struct ControlButtonsView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel

    var body: some View {
        HStack {
            Button() {
                timerViewModel.resetAll()
            } label: {
                Text("Reset All")
            }
            .withResetButtonStyle(color: Color.green)
            Spacer()
            Button() {
                timerViewModel.playPauseTimer()
            } label: {
                Text("Play/Pause")
            }
            .withResetButtonStyle(color: Color.green)
        }
        .padding()    }
}
/*
struct ControlButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlButtonsView(timersModel: TimersModel.exampleTimersModel)
    }
}
 */
