//
//  ContentView.swift
//  Moonboard Timer
//
//  Created by Oliver Kerr on 5/6/22.
//

//Todo: Display full array


import SwiftUI

struct CountDownView: View {
    @StateObject private var timerViewModel = TimerViewModel()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                TimerButtonsRowView()
                    .padding(10)
                TimerView()
                TimesListView()
                ControlButtonsView()
            }
        }
        .environmentObject(timerViewModel)
    }
}

struct CountDownView_Previews: PreviewProvider {
    static var previews: some View {
        CountDownView()
    }
}
