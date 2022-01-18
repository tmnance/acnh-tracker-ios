//
//  ActiveHours.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 1/16/22.
//

import SwiftUI

struct ActiveHours: View {
    let hoursActive: Set<Int>
    let monthsAvailable: Set<Int>
    @State var latestCurrentDate = Date()
    let timer = Timer.publish(every: 60*5, on: .main, in: .common).autoconnect()

    var timeAsPercentageOfDay: CGFloat {
        let calendar = Calendar.current // or e.g. Calendar(identifier: .persian)
        let hour = calendar.component(.hour, from: latestCurrentDate)
        let minute = calendar.component(.minute, from: latestCurrentDate)
        return CGFloat(hour * 60 + minute) / CGFloat(24 * 60)
    }

    private struct Config {
        static let borderWidth:CGFloat = 1.0
        static let availableColor = Color(red: 184 / 255, green: 210 / 255, blue: 82 / 255)
        static let borderAndTextColor = Color(red: 92 / 255, green: 85 / 255, blue: 60 / 255)
        static let currentTimeMarkerHeight = 20.0
        static let currentTimeMarkerOffsetY = 2.0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // draw AM/PM labels
            if Globals.useAmPm {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        ForEach(0..<2) { dayAmPmSegment in
                            Text("\(dayAmPmSegment == 0 ? "AM" : "PM")")
                                .font(.system(size: 8))
                                .foregroundColor(Config.borderAndTextColor)
                                .offset(x: ((geo.size.width - Config.borderWidth) / 2) * CGFloat(dayAmPmSegment))
                        }
                    }
                }
                .frame(height: 10)
            }

            // draw hour labels
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    ForEach(0..<4) { daySixHourSegment in
                        let hourDisplay = "\(Globals.useAmPm ? abs(daySixHourSegment * 6 - 6) % 12 + 6 : daySixHourSegment * 6)"
                        Text("\(hourDisplay)")
                            .font(.system(size: 8))
                            .foregroundColor(Config.borderAndTextColor)
                            .offset(x: ((geo.size.width - Config.borderWidth) / 4) * CGFloat(daySixHourSegment))
                    }
                }
            }
            .frame(height: 10)

            // draw active time plot
            GeometryReader { geo in
                ZStack(alignment: .bottomLeading) {
                    // draw grid lines
                    ForEach(0..<25) { mark in
                        Rectangle()
                            .fill(Config.borderAndTextColor)
                            .frame(width: Config.borderWidth, height: getMarkHeight(mark))
                            .offset(x: CGFloat(mark) * ((geo.size.width - Config.borderWidth) / 24), y: 0)
                            .zIndex(1)
                    }

                    ForEach(getActiveHourRanges(), id: \.0) { (startHour, endHour) in
                        Rectangle()
                            .fill(Config.availableColor)
                            .cornerRadius(5)
                            .frame(
                                width: ((geo.size.width - Config.borderWidth) / 24) * CGFloat(endHour - startHour + 1),
                                height: 10.0
                            )
                            .offset(
                                x: ((geo.size.width - Config.borderWidth) / 24) * CGFloat(startHour),
                                y: -2
                            )
                            .zIndex(0)
                    }

                    // square out rounded corners if active through midnight
                    if hoursActive.contains(0) && hoursActive.contains(23) {
                        Rectangle()
                            .fill(Config.availableColor)
                            .frame(
                                width: ((geo.size.width - Config.borderWidth) / 24) / 2,
                                height: 10.0
                            )
                            .offset(
                                x: 0,
                                y: -2
                            )
                            .zIndex(0)
                        Rectangle()
                            .fill(Config.availableColor)
                            .frame(
                                width: ((geo.size.width - Config.borderWidth) / 24) / 2,
                                height: 10.0
                            )
                            .offset(
                                x: ((geo.size.width - Config.borderWidth) / 24) * 23.5,
                                y: -2
                            )
                            .zIndex(0)
                    }

                    // current time marker
                    Rectangle()
                        .fill(Color.red)
                        .frame(
                            width: Config.borderWidth * 2,
                            height: Config.currentTimeMarkerHeight
                        )
                        .offset(
                            x: (geo.size.width - Config.borderWidth) * timeAsPercentageOfDay,
                            y: Config.currentTimeMarkerOffsetY
                        )
                        .zIndex(2)
                        .onReceive(timer) { _ in
                            self.latestCurrentDate = Date()
                        }
                    Rectangle()
                        .fill(Color.red)
                        .frame(
                            width: Config.borderWidth * 4,
                            height: Config.borderWidth
                        )
                        .offset(
                            x: (geo.size.width - Config.borderWidth) * timeAsPercentageOfDay - Config.borderWidth,
                            y: Config.currentTimeMarkerOffsetY - Config.currentTimeMarkerHeight
                        )
                        .zIndex(2)
                    Rectangle()
                        .fill(Color.red)
                        .frame(
                            width: Config.borderWidth * 4,
                            height: Config.borderWidth
                        )
                        .offset(
                            x: (geo.size.width - Config.borderWidth) * timeAsPercentageOfDay - Config.borderWidth,
                            y: Config.currentTimeMarkerOffsetY
                        )
                        .zIndex(2)
                }
            }
            .frame(height: 20)

            Rectangle()
                .fill(Config.borderAndTextColor)
                .frame(maxWidth: .infinity, minHeight: Config.borderWidth, maxHeight: Config.borderWidth)
        }
        .padding(.horizontal, 10)
        .opacity(isAvailableInCurrentMonth() ? 1 : 0.5)
    }

    private func getMarkHeight(_ mark: Int) -> CGFloat {
        if mark % 6 == 0 {
            return 20.0
        }
        else if mark % 3 == 0 {
            return 15.0
        }
        else {
            return 10.0
        }
    }

    private func getActiveHourRanges() -> [(Int,Int)] {
        var result: [(Int, Int)] = []
        let hoursActiveArr = Array(hoursActive.sorted(by: <))

        var index = 0
        while index < hoursActiveArr.count {
            let startHour = hoursActiveArr[index]
            while index + 1 < hoursActiveArr.count && hoursActiveArr[index] + 1 == hoursActiveArr[index + 1] {
                index += 1
            }
            result.append((startHour, hoursActiveArr[index]))
            index += 1
        }

        return result
    }

    private func isAvailableInCurrentMonth() -> Bool {
        return monthsAvailable.contains(Globals.currentMonthIndex)
    }
}

struct HourAvailability_Previews: PreviewProvider {
    private static let allMonths = Set([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
    static var previews: some View {
        ActiveHours(
            hoursActive: Set([8, 9, 10, 11, 12, 13, 14, 15, 16]),
            monthsAvailable: allMonths
        )
    }
}
