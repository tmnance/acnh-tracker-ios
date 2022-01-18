//
//  MonthAvailability.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import SwiftUI

struct MonthAvailability: View {
    let monthsAvailable: Set<Int>
    private let currentColor = Color.white
    private let availableColor = Color(red: 184 / 255, green: 210 / 255, blue: 82 / 255)
    private let borderAndTextColor = Color(red: 92 / 255, green: 85 / 255, blue: 60 / 255)

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(zip(Constants.monthFirstLetters.indices, Constants.monthFirstLetters)), id: \.0) { index, month in
                Text("**\(month)**")//isCurrMonth(index) ? "**\(month)**" : "\(month)")
                    .font(.system(size: 10))
                    .glowBorder(color: .white, lineWidth: 1)
                    .foregroundColor(borderAndTextColor)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: 16)
//                    .padding(1)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(isAvailableMonth(index) ? availableColor : .clear)
                    )
                    .padding(2)
                    .border(isCurrentMonth(index) ? Color.red : .clear, width: 1.5)
                    .padding(1)
                    .border(borderAndTextColor, width: 0.5)
                    .padding(.leading, -0.5)
                    .opacity(isAvailableMonth(index) ? 1 : 0.5)
            }
        }
        .padding(.leading, 0.5)
    }
    
    private func isCurrentMonth(_ index: Int) -> Bool {
        return index == Globals.currentMonthIndex
    }
    
    private func isAvailableMonth(_ index: Int) -> Bool {
        return monthsAvailable.contains(index)
    }
}

struct MonthAvailability_Previews: PreviewProvider {
    static var previews: some View {
        MonthAvailability(monthsAvailable: Set([3, 4, 5, 6, 7, 8]))
    }
}
