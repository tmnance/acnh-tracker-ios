//
//  Globals.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import Foundation

public struct Globals {
    static let currentMonthIndex = Calendar.current.dateComponents([.month], from: Date()).month! - 1
    static var useAmPm: Bool {
        let format = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.autoupdatingCurrent)
        return format!.contains("a")
    }
}
