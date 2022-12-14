//
//  ContentView.swift
//  Moonboard Timer
//
//  Created by Oliver Kerr on 5/6/22.
//

//Todo: Display full array


import SwiftUI

struct CountdownView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private  var dismiss

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                TimerButtonsRowView()
                    .padding(10)
                TimerView()
                TimesListView(filter: timerViewModel.countdownTimerHistory.id)
                ControlButtonsView()
                Button() {
                    timerViewModel.saveWorkout()
                    dismiss()
                } label: {
                    Text("save")
                }
                .withResetButtonStyle(color: Color.green)
            }
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
    }
}
