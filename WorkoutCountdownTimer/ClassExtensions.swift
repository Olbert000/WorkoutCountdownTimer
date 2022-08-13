//
//  TimeIntervalExtension.swift
//  Moonboard Timer
//
//  Created by Kate Riordan on 11/7/2022.
//

import Foundation
import CoreData



extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

extension Array where Element == ChangeToCoreDataEntity {
    var cumulativeTimes : [TimeInterval] {
            let totalTimes = self.map {$0.totalTimeForThisCountdown}.reversed()
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

//TODO: Change name to SaveableCountdown

extension CountdownEntity {
    convenience init (saveableCountdown: ChangeToCoreDataEntity, viewContext: NSManagedObjectContext) {
        self.init(context: viewContext)
        self.countingDownFrom = saveableCountdown.countingDownFrom
        self.overTime = saveableCountdown.overTime
        self.startTime = saveableCountdown.startTime
    }
    
    static func < (lhs: CountdownEntity, rhs: CountdownEntity) throws -> Bool {
        guard
            let lhsStartTime = lhs.startTime,
            let rhsStartTime = rhs.startTime
        else {
 //           throw CountdownError.countdownHasNoData
            return true
        }
        return lhsStartTime < rhsStartTime
    }
    
    static func > (lhs: CountdownEntity, rhs: CountdownEntity) throws -> Bool {
        guard
            let lhsStartTime = lhs.startTime,
            let rhsStartTime = rhs.startTime
        else {
//            throw CountdownError.countdownHasNoData
            return true
        }
        return lhsStartTime > rhsStartTime
    }
    
    var totalTimeForThisCountdown: TimeInterval {
        return countingDownFrom + overTime
    }

}

extension WorkoutEntity {
    convenience init (countdowns: [ChangeToCoreDataEntity], viewContext: NSManagedObjectContext) {
        self.init(context: viewContext)
        self.countdowns = NSSet(array: countdowns.map{CountdownEntity(saveableCountdown: $0, viewContext: viewContext)})
        self.startedAt = countdowns.first?.startTime
    }
}
