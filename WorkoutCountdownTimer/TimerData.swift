//
//  TimerData.swift
//  Moonboard Timer
//
//  Created by Kate Riordan on 20/7/2022.
//

import Foundation

//Rename to live countdown!!
struct CountDown {
    let countingDownFrom: TimeInterval
    var startStopTimes: [Date]
    
    var isPaused: Bool {
        return startStopTimes.count % 2 == 0
    }

    func totalTimeForThisCountdown(currentTime: Date) -> TimeInterval{
        return countingDownFrom - stride(from:0, to: startStopTimes.endIndex, by: 2)
            .map{$0 < startStopTimes.index(before: startStopTimes.endIndex) ? startStopTimes[$0.advanced(by:1)] - startStopTimes[$0] : currentTime - startStopTimes[$0]}
            .reduce(0,+)
    }
    
    init(startedAt: Date, countingDownFrom: TimeInterval) {
        self.startStopTimes = [startedAt]
        self.countingDownFrom = countingDownFrom
    }
}

//Rename to completedCountDown
struct SaveableCountDown: Hashable {
    let countingDownFrom: TimeInterval
    let overTime: TimeInterval
    let startTime: Date

    var totalTimeForThisCountDown: TimeInterval {
        return countingDownFrom + overTime
    }
  
    init(countingDownFrom: TimeInterval, overTime: TimeInterval, startTime: Date) {
        self.countingDownFrom = countingDownFrom
        self.overTime = overTime
        self.startTime = startTime
    }
}

//I don't think I need this!
struct Workout {
    let countDowns: [SaveableCountDown]
    
    var date: Date? {
        return countDowns.first?.startTime
    }
    
    init(countDowns: [SaveableCountDown]) {
        self.countDowns = countDowns
    }
}

enum CountDownError: Error {
    case countDownHasNoData
}
