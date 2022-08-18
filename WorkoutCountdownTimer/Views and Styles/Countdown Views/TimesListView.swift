//
//  TimesListView.swift
//  Moonboard Timer
//
//  Created by Oliver Kerr on 23/6/22.
//

import SwiftUI
import CoreData

struct TimesListView: View {
    @FetchRequest var fetchedWorkout: FetchedResults<WorkoutEntity>
    
    init(filter: UUID) {
        _fetchedWorkout = FetchRequest<WorkoutEntity>(sortDescriptors: [], predicate: NSPredicate(format: "id_ = %@", filter as CVarArg))
    }
    
    var body: some View {
        if let countdownTimerHistory = fetchedWorkout.first?.countdowns {
            List(Array(zip(countdownTimerHistory, countdownTimerHistory.cumulativeTimes)), id: \.self.0) { timeInterval, cumulativeTime in
                HStack {
                    TimeHistoryTextView(timeInterval: timeInterval.countingDownFrom, color: Color.green, totalTime: false)
                        .padding(2)
                    TimeHistoryTextView(timeInterval: timeInterval.overTime, color: Color.red, totalTime: false)
                        .padding(2)
                    Spacer()
                    TimeHistoryTextView(timeInterval: cumulativeTime, color: Color.white, totalTime: true)
                        .padding(2)
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
}
/*
 struct TimesListView_Previews: PreviewProvider {
 static var previews: some View {
 TimesListView(timersModel: TimersModel.exampleTimersModel)
 }
 }
 */

