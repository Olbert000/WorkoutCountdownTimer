//
//  TimerFunctions.swift
//  Moonboard Timer
//
//  Created by Kate Riordan on 20/7/2022.
//

import Foundation

class TimerFunctions {
    static func transformCountdownToHistory(totalCountdownTime: TimeInterval?, countingDownFrom: TimeInterval?, startTime: Date?) -> ChangeToCoreDataEntity? {
        guard
            let countdownTime = totalCountdownTime,
            let countingDownFrom = countingDownFrom,
            let startTime = startTime
            else { return nil }
        let actualCountingDownFrom = (countingDownFrom > countdownTime) ? countdownTime : countingDownFrom
        let actualOverTime = (countingDownFrom > countdownTime) ? 0 : countdownTime - countingDownFrom
        return ChangeToCoreDataEntity(countingDownFrom: actualCountingDownFrom, overTime: actualOverTime, startTime: startTime)
    }
}
