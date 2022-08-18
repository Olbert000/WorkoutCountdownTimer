//
//  TimerData.swift
//  Moonboard Timer
//
//  Created by Kate Riordan on 20/7/2022.
//

import Foundation

struct LiveCountdown {
    let countingDownFrom: TimeInterval
    var startStopTimes: [Date]
    
    var isPaused: Bool {
        return startStopTimes.count % 2 == 0
    }

    func totalTimeForThisCountdown(at currentTime: Date) -> TimeInterval{
        return countingDownFrom - stride(from:0, to: startStopTimes.endIndex, by: 2)
            .map{$0 < startStopTimes.index(before: startStopTimes.endIndex) ? startStopTimes[$0.advanced(by:1)] - startStopTimes[$0] : currentTime - startStopTimes[$0]}
            .reduce(0,+)
    }
    
    func currentCountdownExpired(by currentTime: Date) -> Bool {
        return currentCountdownTime(at: currentTime) > countingDownFrom
    }
    
    func currentCountdownTime(at currentTime: Date) -> TimeInterval {
        return countingDownFrom - totalTimeForThisCountdown(at: currentTime)
    }
    
    func remainingTime(at currentTime: Date) -> TimeInterval {
        return countingDownFrom - currentCountdownTime(at: currentTime)
    }
    
    init(startedAt: Date, countingDownFrom: TimeInterval) {
        self.startStopTimes = [startedAt]
        self.countingDownFrom = countingDownFrom
    }
}

enum CountdownError: Error {
    case countdownHasNoData
}
