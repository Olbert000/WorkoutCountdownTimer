//
//  TimerFunctions.swift
//  Moonboard Timer
//
//  Created by Kate Riordan on 20/7/2022.
//

import Foundation

class TimerFunctions {
    static func transformCountDownToHistory(totalCountDownTime: TimeInterval?, countingDownFrom: TimeInterval?, startTime: Date?) -> ChangeToCoreDataEntity? {
        guard
            let countDownTime = totalCountDownTime,
            let countingDownFrom = countingDownFrom,
            let startTime = startTime
            else { return nil }
        let actualCountingDownFrom = (countingDownFrom > countDownTime) ? countDownTime : countingDownFrom
        let actualOverTime = (countingDownFrom > countDownTime) ? 0 : countDownTime - countingDownFrom
        return ChangeToCoreDataEntity(countingDownFrom: actualCountingDownFrom, overTime: actualOverTime, startTime: startTime)
    }
}
