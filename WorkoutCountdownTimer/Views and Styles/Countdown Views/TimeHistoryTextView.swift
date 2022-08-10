//
//  TimeHistoryTextView.swift
//  Moonboard Timer
//
//  Created by Kate Riordan on 9/7/2022.
//

import SwiftUI

struct TimeHistoryTextView: View {
    let timeInterval: TimeInterval
    let color: Color
    let totalTime: Bool
    
    var body: some View {
        Text(timeInterval.string(short: false, showDeciseconds: false) )
            .withListTimesStyle(color: color, totalTime: totalTime)
    }
}

struct TimeHistoryTextView_Previews: PreviewProvider {
    static var previews: some View {
        TimeHistoryTextView(timeInterval: TimeInterval(100), color:Color.red, totalTime: true)
    }
}

