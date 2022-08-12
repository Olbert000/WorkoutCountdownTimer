//
//  TimeIntervalExtension.swift
//  Moonboard Timer
//
//  Created by Kate Riordan on 11/7/2022.
//

import Foundation




extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

extension Array where Element == SaveableCountDown {
    var cumulativeTimes : [TimeInterval] {
            let totalTimes = self.map {$0.totalTimeForThisCountDown}.reversed()
            return totalTimes.reduce(into: []) { $0.append(($0.last ?? 0) + $1) }.reversed()
    }
}

extension TimeInterval {
    func string(short: Bool = true, showDeciseconds: Bool = false) -> String {
        let absInterval = abs(self)
        let decisecondString: String
        let formatter = DateComponentsFormatter()
        let time = Int(absInterval.rounded())
        let moreThanZeroHours = time / 3600 > 0
        let moreThanZeroMinutes = (time / 60) % 60 > 0
        
        if moreThanZeroHours {
            formatter.allowedUnits.insert(.hour)
        }
        if moreThanZeroMinutes || !short {
            formatter.allowedUnits.insert(.minute)
        }
        formatter.allowedUnits.insert(.second)
        if !short {
            formatter.zeroFormattingBehavior = .pad
        }

        if showDeciseconds {
            let deciseconds = NumberFormatter()
            deciseconds.maximumIntegerDigits = 0
            deciseconds.minimumFractionDigits = 0
            deciseconds.maximumFractionDigits = 1
            deciseconds.alwaysShowsDecimalSeparator = false
            let fractionalPart = NSNumber(value: absInterval.truncatingRemainder(dividingBy: 1))
            decisecondString = deciseconds.string(from: fractionalPart)!
        } else {
            decisecondString = ""
        }
        
        return formatter.string(from: absInterval)! + decisecondString
    }
}

extension CountDownEntity {
//    convenience init (saveableCountDown: SaveableCountDown) {
//        self.init()
//        self.countingDownFrom = saveableCountDown.countingDownFrom
//        self.overTime = saveableCountDown.overTime
//        self.startTime = saveableCountDown.startTime
//    }
    
    static func < (lhs: CountDownEntity, rhs: CountDownEntity) throws -> Bool {
        guard
            let lhsStartTime = lhs.startTime,
            let rhsStartTime = rhs.startTime
        else {
 //           throw CountDownError.countDownHasNoData
            return true
        }
        return lhsStartTime < rhsStartTime
    }
    
    static func > (lhs: CountDownEntity, rhs: CountDownEntity) throws -> Bool {
        guard
            let lhsStartTime = lhs.startTime,
            let rhsStartTime = rhs.startTime
        else {
//            throw CountDownError.countDownHasNoData
            return true
        }
        return lhsStartTime > rhsStartTime
    }
}

extension WorkoutEntity {
//    convenience init (countDowns: [SaveableCountDown]) {
//        self.init()
//        self.countDowns = countDowns
//    }
//    
//    convenience init (workout: Workout) {
//        self.init()
//        self.countDowns = workout.countDowns
//    }
}
