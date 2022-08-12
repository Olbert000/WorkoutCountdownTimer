//
//  TimerViewModel.swift
//  Moonboard Timer
//
//  Created by Kate Riordan on 20/7/2022.
//

import Foundation
import CoreData

//TODO: Make countDOwnTimes a user setting.

@MainActor class TimerViewModel: ObservableObject{
    static let countDownTimes: [TimeInterval] = [30,60,90,180,300,600]
    static let timerInterval: Double = 0.1
    
    @Published var countDown: CountDown?
    @Published var countDownTimerHistory: [SaveableCountDown]
    
    @Published private var currentTime: Date
    private var timer: Timer
 
    var countDownHasCommenced: Bool {
        return countDown != nil
    }
    
    var currentCountDownHasExpired: Bool? {
        guard
            let countingDownFrom = countDown?.countingDownFrom,
            let currentCountDownTime = currentCountDownTime
            else { return nil }
        return currentCountDownTime > countingDownFrom
    }
    
    var totalTimeForThisCountDown: TimeInterval? {
        return countDown?.totalTimeForThisCountdown(currentTime: currentTime)
    }
    
    var currentCountDownTime: TimeInterval? {
        guard
            let countingDownFrom = countDown?.countingDownFrom,
            let totalTimeForThisCountDown = totalTimeForThisCountDown
            else { return nil }
        return countingDownFrom - totalTimeForThisCountDown
    }
    
    var remainingTime: TimeInterval? {
        guard
            let countingDownFrom = countDown?.countingDownFrom,
            let currentCountDownTime = currentCountDownTime
            else { return nil }
        return countingDownFrom - currentCountDownTime
    }
    
    //UI Methods:
    func commenceCountDown(from: TimeInterval) {
        let now = Date.now
        if let saveableCountDown = TimerFunctions.transformCountDownToHistory(totalCountDownTime: currentCountDownTime, countingDownFrom: countDown?.countingDownFrom, startTime: countDown?.startStopTimes.first) {
            countDownTimerHistory.insert(saveableCountDown, at: 0)
        }
        countDown = CountDown(startedAt: now, countingDownFrom: from)
    }
    
    func playPauseTimer() {
        countDown?.startStopTimes.append(currentTime)
    }
    
    func resetAll() {
        countDown = nil
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
        self.countDown = nil
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



