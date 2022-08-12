//
//  TimerViewModel.swift
//  Moonboard Timer
//
//  Created by Kate Riordan on 20/7/2022.
//

import Foundation
import CoreData

//TODO: Make countdownTimes a user setting.
//TODO: Change countDown to countdown - countdown is a complete word on it's own (noun version).
//TODO: Remove ChangeToCoreDataEntity and replace with CountDownEntity.

@MainActor class TimerViewModel: ObservableObject{
    static let countDownTimes: [TimeInterval] = [30,60,90,180,300,600]
    static let timerInterval: Double = 0.1
    
    @Published var liveCountdown: LiveCountDown?
    @Published var countDownTimerHistory: [ChangeToCoreDataEntity]
    
    @Published private var currentTime: Date
    private var timer: Timer
 
    var countDownHasCommenced: Bool {
        return liveCountdown != nil
    }
    
    var currentCountDownHasExpired: Bool? {
        guard
            let countingDownFrom = liveCountdown?.countingDownFrom,
            let currentCountDownTime = currentCountDownTime
            else { return nil }
        return currentCountDownTime > countingDownFrom
    }
    
    var totalTimeForThisCountDown: TimeInterval? {
        return liveCountdown?.totalTimeForThisCountdown(currentTime: currentTime)
    }
    
    var currentCountDownTime: TimeInterval? {
        guard
            let countingDownFrom = liveCountdown?.countingDownFrom,
            let totalTimeForThisCountDown = totalTimeForThisCountDown
            else { return nil }
        return countingDownFrom - totalTimeForThisCountDown
    }
    
    var remainingTime: TimeInterval? {
        guard
            let countingDownFrom = liveCountdown?.countingDownFrom,
            let currentCountDownTime = currentCountDownTime
            else { return nil }
        return countingDownFrom - currentCountDownTime
    }
    
    //UI Methods:
    func commenceCountDown(from: TimeInterval) {
        let now = Date.now
        if let saveableCountDown = TimerFunctions.transformCountDownToHistory(totalCountDownTime: currentCountDownTime, countingDownFrom: liveCountdown?.countingDownFrom, startTime: liveCountdown?.startStopTimes.first) {
            countDownTimerHistory.insert(saveableCountDown, at: 0)
        }
        liveCountdown = LiveCountDown(startedAt: now, countingDownFrom: from)
    }
    
    func playPauseTimer() {
        liveCountdown?.startStopTimes.append(currentTime)
    }
    
    func resetAll() {
        liveCountdown = nil
        countDownTimerHistory = []
    }
    
    func saveWorkout(viewContext: NSManagedObjectContext) {
        let _ = WorkoutEntity(countDowns: countDownTimerHistory, viewContext: viewContext)
        try? viewContext.save()
        resetAll()
        
    }
    
    @objc private func tick() {
        let now = Date.now
        currentTime = now
    }
    
    init(){
        self.liveCountdown = nil
        self.countDownTimerHistory = []
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



