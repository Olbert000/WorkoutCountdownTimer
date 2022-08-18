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

extension Array where Element == CountdownEntity {
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

//TODO: Change name to SaveableCountdown or CompletedCountdown

extension CountdownEntity {
    convenience init(liveCountdown: LiveCountdown, at currentTime: Date, workout: WorkoutEntity, viewContext: NSManagedObjectContext) {
        let countdownTime = liveCountdown.currentCountdownTime(at: currentTime)
        let countingDownFrom = liveCountdown.countingDownFrom
        self.init(context: viewContext)
        self.countingDownFrom = (countingDownFrom > countdownTime) ? countdownTime : countingDownFrom
        self.overTime = (countingDownFrom > countdownTime) ? 0 : countdownTime - countingDownFrom
        self.startTime_ = liveCountdown.startStopTimes.first
        self.workout = workout
        if self.workout!.startTime_ == nil {
            self.workout!.startTime_ = self.startTime_!
        }

    }
    
    var startTime: Date {
        return startTime_!
    }
    
    static func < (lhs: CountdownEntity, rhs: CountdownEntity) throws -> Bool {
        return lhs.startTime < rhs.startTime
    }
    
    static func > (lhs: CountdownEntity, rhs: CountdownEntity) throws -> Bool {
        return lhs.startTime > rhs.startTime
    }
    
    var totalTimeForThisCountdown: TimeInterval {
        return countingDownFrom + overTime
    }
}

extension WorkoutEntity {
    convenience init(viewContext: NSManagedObjectContext) {
        self.init(context: viewContext)
        self.countdowns_ = []
        self.saved = false
    }
    
    var countdowns: [CountdownEntity] {
        if let countdownsSet = countdowns_ as? Set<CountdownEntity>,
           let sortedCountdownSet = try? countdownsSet.sorted(by: >) {
            return Array(sortedCountdownSet)
        } else {
            return []
        }
    }
    
    var startTime: Date {
        guard let startTime = countdowns.first?.startTime else {
            return Date.init(timeIntervalSince1970: 0)
        }
        return startTime
    }

    public var id: UUID {
        guard let id = id_ else {
            id_ = UUID()
            return id_!
        }
        return id
    }
    func insert(_ countdown: CountdownEntity) {
        countdowns_ = countdowns_?.addingObjects(from: [countdown]) as NSSet?
        self.objectWillChange.send()
    }
}
