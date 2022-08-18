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
    static let timerInterval: TimeInterval = 0.1
    
    @Published var liveCountdown: LiveCountdown?
    var countdownTimerHistory: WorkoutEntity

    @Published private var currentTime: Date
    private var timer: Timer
    private var viewContext: NSManagedObjectContext
 
    var remainingTime: TimeInterval? {
        return liveCountdown?.remainingTime(at: currentTime)
    }
    
    var currentCountdownHasExpired: Bool? {
        return liveCountdown?.currentCountdownExpired(by: currentTime)
    }
    
    var countdownHasCommenced: Bool {
        return liveCountdown != nil
    }
    
    //UI Methods:
    func commenceCountdown(from: TimeInterval) {
        if let liveCountdown = liveCountdown {
            countdownTimerHistory.insert(CountdownEntity(liveCountdown: liveCountdown, at: currentTime, workout: countdownTimerHistory, viewContext: viewContext))
        }
        liveCountdown = LiveCountdown(startedAt: currentTime, countingDownFrom: from)
    }
    
    func playPauseTimer() {
        liveCountdown?.startStopTimes.append(currentTime)
    }
    
    func resetAll() {
        liveCountdown = nil
        countdownTimerHistory = WorkoutEntity(viewContext: viewContext)
    }
    
    func saveWorkout() {
        countdownTimerHistory.saved = true
        try? viewContext.save()
        resetAll()
    }
    
    init(){
        let now = Date.now
        self.liveCountdown = nil
        self.currentTime = now
        self.viewContext = PersistenceController.shared.container.viewContext
        self.countdownTimerHistory = WorkoutEntity(viewContext: viewContext)
        self.timer = Timer()
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



