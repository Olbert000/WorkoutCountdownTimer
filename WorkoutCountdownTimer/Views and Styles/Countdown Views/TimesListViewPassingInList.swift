//
//  TimesListViewPassingInList.swift
//  WorkoutCountdownTimer
//
//  Created by Oliver Kerr on 12/8/2022.
//

import SwiftUI
import CoreData

struct TimesListViewPassingInList: View {
    var countdownList: [CountdownEntity]
    
    var body: some View {
//        List(Array(zip(countdownList, countdownList.cumulativeTimes)), id: \.self.0) { timeInterval, cumulativeTime in
        List(countdownList, id: \.self) { timeInterval in
            HStack {
                TimeHistoryTextView(timeInterval: timeInterval.countingDownFrom, color: Color.green, totalTime: false)
                    .padding(2)
                TimeHistoryTextView(timeInterval: timeInterval.overTime, color: Color.red, totalTime: false)
                    .padding(2)
                Spacer()
            }
        }
        .colorScheme(.dark)
        .onAppear() {
            UITableView.appearance().separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 17)
        }
        .listStyle(.plain)
        .padding([.top], 20)
        
    }
}

//struct TimesListViewPassingInList_Previews: PreviewProvider {
//    static var previews: some View {
//        TimesListViewPassingInList()
//    }
//}
