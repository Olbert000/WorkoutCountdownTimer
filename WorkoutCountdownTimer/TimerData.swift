//
//  TimerData.swift
//  Moonboard Timer
//
//  Created by Kate Riordan on 20/7/2022.
//

import Foundation

//TODO: Make codeable.

struct CountDown {
    
    let id: UUID
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
    
    init(id: UUID = UUID(), startedAt: Date, countingDownFrom: TimeInterval) {
        self.id = id
        self.startStopTimes = [startedAt]
        self.countingDownFrom = countingDownFrom
    }
}

struct SaveableCountDown : Identifiable, Hashable{
    let id: UUID
    let countingDownFrom: TimeInterval
    let overTime: TimeInterval
    let startTime: Date

    var totalTimeForThisCountDown: TimeInterval {
        return countingDownFrom + overTime
    }
  
    init(id: UUID = UUID(), countingDownFrom: TimeInterval, overTime: TimeInterval, startTime: Date) {
        self.id = id
        self.countingDownFrom = countingDownFrom
        self.overTime = overTime
        self.startTime = startTime
    }
}

struct WorkOut: Identifiable, Hashable {
    let id: UUID
    let countDowns: [SaveableCountDown]
    
    var date: Date? {
        return countDowns.first?.startTime
    }
    
    init(id: UUID = UUID(), countDowns: [SaveableCountDown]) {
        self.id = id
        self.countDowns = countDowns
    }
}
