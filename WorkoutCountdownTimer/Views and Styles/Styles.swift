//
//  Styles.swift
//  Moonboard Timer
//
//  Created by Oliver Kerr on 19/6/22.
//

import Foundation
import SwiftUI

extension Button {
    func withTimerButtonStyle(color: Color) -> some View {
        self.foregroundColor(.white)
            .font(Font.body.bold())
            .padding(10)
            .padding(.horizontal, 20)
            .background(color)
            .cornerRadius(10)
    }
    
    func withResetButtonStyle(color: Color) -> some View {
        self.foregroundColor(.white)
            .font(Font.body.bold())
            .padding(10)
            .padding(.horizontal, 20)
            .background(color)
            .cornerRadius(10)
    }
}

extension Text {
    func withTimerTextStyle(color: Color) -> some View {
        self.foregroundColor(.white)
            .font(Font.body.bold().monospacedDigit())
            .padding(23)
            .background(color)
            .cornerRadius(10)
    }
    
    func withMainTimerStyle(_ timesUp: Bool) -> some View {
        let textColor = timesUp ? Color.red : Color.white
    
        return self.foregroundColor(textColor)
            .fontWeight(.ultraLight)
            .font(.system(size: 100).monospacedDigit())
    }
    
    func withListTimesStyle(color: Color, totalTime: Bool = false) -> some View {
        if totalTime {
            return self.padding([.bottom],1)
                .foregroundColor(color)
                .font(.system(size: 25, weight: .bold))
                .monospacedDigit()
        } else {
            return self.padding([.trailing], 20)
                .foregroundColor(color)
                .font(.system(size: 25))
                .monospacedDigit()
        }
    }
    
    func withCountStyle() -> some View {
        return self.foregroundColor(Color.white)
            .font(.system(size: 30))
            .frame(maxHeight: 90, alignment: .top)
            .padding(25)
    }
}

