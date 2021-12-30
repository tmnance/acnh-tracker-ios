//
//  MonthAvailability.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import SwiftUI

struct MonthAvailability: View {
    let monthsAvailable: Set<Int>
    private let currMonthColor = Color.white

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(zip(Constants.monthFirstLetters.indices, Constants.monthFirstLetters)), id: \.0) { index, month in
                Text("**\(month)**")//isCurrMonth(index) ? "**\(month)**" : "\(month)")
                    .font(.system(size: 10))
                    .glowBorder(color: .white, lineWidth: 1)
                    .foregroundColor(isCurrMonth(index) ? currMonthColor : .black)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: 16)
                    .background(
//                        if index == Globals.currentMonthIndex {
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(
                                    currMonthColor,
                                    style: StrokeStyle(lineWidth: isCurrMonth(index) ? 1 : 0, dash: [2])
                                )
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .foregroundColor(isAvailableMonth(index) ? .green : .gray)
                                )
                                .opacity(isCurrMonth(index) ? 1 : 0.4)
                    )
//                    .opacity(1)//isCurrMonth(index) ? 1 : 0.75)
            }
        }
    }
    
    private func isCurrMonth(_ index: Int) -> Bool {
        return index == Globals.currentMonthIndex
    }
    
    private func isAvailableMonth(_ index: Int) -> Bool {
        return monthsAvailable.contains(index)
    }
}

struct MonthAvailability_Previews: PreviewProvider {
    static var previews: some View {
        MonthAvailability(monthsAvailable: Set([3, 4, 5]))
    }
}
