//
//  MonthAvailability.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import SwiftUI

struct MonthAvailability: View {
    let monthsAvailable: Set<Int>
    
    private struct Config {
        static let monthBoxBorderWidth:CGFloat = 0.5
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(zip(Constants.monthFirstLetters.indices, Constants.monthFirstLetters)), id: \.0) { index, month in
                Text("**\(month)**")
                    .font(.system(size: 10))
                    .glowBorder(color: .white, lineWidth: 1)
                    .foregroundColor(Constants.Colors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: 16)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(isAvailableMonth(index) ? Constants.Colors.rangeActiveHighlight : .clear)
                    )
                    .padding(2)
                    .border(isCurrentMonth(index) ? Constants.Colors.rangeCurrentMarker : .clear, width: 1.5)
                    .padding(1)
                    .border(Constants.Colors.primaryBorder, width: Config.monthBoxBorderWidth)
                    .padding(.leading, -Config.monthBoxBorderWidth)
                    .opacity(isAvailableMonth(index) ? 1 : Config.monthBoxBorderWidth)
            }
        }
        .padding(.leading, Config.monthBoxBorderWidth)
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
