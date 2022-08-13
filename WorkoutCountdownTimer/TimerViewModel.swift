//
//  TimerViewModel.swift
//  Moonboard Timer
//
//  Created by Kate Riordan on 20/7/2022.
//

import Foundation
import CoreData

//TODO: Make countdownTimes a user setting.
//TODO: Remove ChangeToCoreDataEntity and replace with CountdownEntity.

@MainActor class TimerViewModel: ObservableObject{
    static let countdownTimes: [TimeInterval] = [30,60,90,180,300,600]
    static let timerInterval: Double = 0.1
    
    @Published var liveCountdown: LiveCountdown?
    @Published var countdownTimerHistory: [ChangeToCoreDataEntity]
    
    @Published private var currentTime: Date
    private var timer: Timer
 
    var countdownHasCommenced: Bool {
        return liveCountdown != nil
    }
    
    var currentCountdownHasExpired: Bool? {
        guard
            let countingDownFrom = liveCountdown?.countingDownFrom,
            let currentCountdownTime = currentCountdownTime
            else { return nil }
        return currentCountdownTime > countingDownFrom
    }
    
    var totalTimeForThisCountdown: TimeInterval? {
        return liveCountdown?.totalTimeForThisCountdown(currentTime: currentTime)
    }
    
    var currentCountdownTime: TimeInterval? {
        guard
            let countingDownFrom = liveCountdown?.countingDownFrom,
            let totalTimeForThisCountdown = totalTimeForThisCountdown
            else { return nil }
        return countingDownFrom - totalTimeForThisCountdown
    }
    
    var remainingTime: TimeInterval? {
        guard
            let countingDownFrom = liveCountdown?.countingDownFrom,
            let currentCountdownTime = currentCountdownTime
            else { return nil }
        return countingDownFrom - currentCountdownTime
    }
    
    //UI Methods:
    func commenceCountdown(from: TimeInterval) {
        let now = Date.now
        if let saveableCountdown = TimerFunctions.transformCountdownToHistory(totalCountdownTime: currentCountdownTime, countingDownFrom: liveCountdown?.countingDownFrom, startTime: liveCountdown?.startStopTimes.first) {
            countdownTimerHistory.insert(saveableCountdown, at: 0)
        }
        liveCountdown = LiveCountdown(startedAt: now, countingDownFrom: from)
    }
    
    func playPauseTimer() {
        liveCountdown?.startStopTimes.append(currentTime)
    }
    
    func resetAll() {
        liveCountdown = nil
        countdownTimerHistory = []
    }
    
    func saveWorkout(viewContext: NSManagedObjectContext) {
        let _ = WorkoutEntity(countdowns: countdownTimerHistory, viewContext: viewContext)
        try? viewContext.save()
        resetAll()
        
    }
    
    @objc private func tick() {
        let now = Date.now
        currentTime = now
    }
    
    init(){
        self.liveCountdown = nil
        self.countdownTimerHistory = []
        self.currentTime = Date.now
        self.timer = Timer()
   //     self.timer = Timer.scheduledTimer(timeInterval: TimerViewModel.timerInterval, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            let now = Date.now
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.currentTime = now
            }
        }
        self.timer.tolerance = 0.01
    }
    
    deinit {
        self.timer.invalidate()
    }
}



