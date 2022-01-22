//
//  Constants.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/12/21.
//

import SwiftUI

public struct Constants {
    static let monthFirstLetters = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
    struct Colors {
        static let primaryText = Color(red: 92 / 255, green: 85 / 255, blue: 60 / 255)
        static let primaryBorder = Color(red: 92 / 255, green: 85 / 255, blue: 60 / 255)

        static let rangeActiveHighlight = Color(red: 184 / 255, green: 210 / 255, blue: 82 / 255)
        static let rangeCurrentMarker = Color.red

        static let donateIconFill = Color(red: 102/255, green: 102/255,blue: 102/255)

        static let statusIncompleteText = primaryText
        static let statusCompleteText = Color.green

        static let statusNotYetObtainedBg = Color(red: 0.8, green: 0.8, blue: 0.8).opacity(0.7)
        static let statusObtainedButNotYetDonatedBg = Color(red: 1, green: 1, blue: 0.8).opacity(0.7)
        static let statusCompleteBg = Color(red: 0.8, green: 1, blue: 0.8).opacity(0.7)

        static let statusNotYetObtainedBorder = Color.gray
        static let statusObtainedButNotYetDonatedBorder = Color.yellow
        static let statusCompleteBorder = Color.green

        static func getStatusBgColor(isObtained: Bool, isDonated: Bool? = nil) -> Color {
            guard let isDonated = isDonated else {
                return isObtained ? statusCompleteBg : statusNotYetObtainedBg
            }

            return isDonated ?
                statusCompleteBg :
                isObtained ?
                    statusObtainedButNotYetDonatedBg :
                    statusNotYetObtainedBg
        }

        static func getStatusBorderColor(isObtained: Bool, isDonated: Bool? = nil) -> Color {
            guard let isDonated = isDonated else {
                return isObtained ? statusCompleteBorder : statusNotYetObtainedBorder
            }

            return isDonated ?
                statusCompleteBorder :
                isObtained ?
                    statusObtainedButNotYetDonatedBorder :
                    statusNotYetObtainedBorder
        }

//        static let clear = UIColor.clear
//        static let label = UIColor(named: "label")!

//        static let mainViewBg = UIColor(named: "mainViewBg")!
//
//        static let tint = UIColor(named: "tint")!
//        static let textForTintBackground = UIColor(named: "textForTintBackground")!
//
//        static let tint2 = UIColor(named: "tint2")!
//        static let disabledText = UIColor(named: "disabledText")!
//        static let subText = UIColor(named: "subText")!
//
//        static let popupOverlayBg = UIColor(named: "popupOverlayBg")!
//        static let popupButtonSeparator = UIColor(named: "popupButtonSeparator")!
//
//        static let chartGrid = UIColor(named: "chartGrid")!
//
//        static let listWeekdayBg1 = UIColor(named: "listWeekdayBg1")!
//        static let listWeekdayBg2 = UIColor(named: "listWeekdayBg2")!
//        static let listWeekendBg = UIColor(named: "listWeekendBg")!
//        static let listCheckmark = UIColor(named: "listCheckmark")!
//        static let listRowOverlayBg = UIColor(named: "listRowOverlayBg")!
//        static let listBorder = UIColor(named: "listBorder")!
//        static let listDisabledCellOverlay = UIColor(
//            patternImage: UIImage(named: "disabled-diag-stripe")!
//        ).withAlphaComponent(0.05)
//
//        static let toastText = UIColor(named: "toastText")!
//        static let toastSuccessBg = UIColor(named: "toastSuccessBg")!
//        static let toastErrorBg = UIColor(named: "toastErrorBg")!
//        static let toastWarningBg = UIColor(named: "toastWarningBg")!
//        static let toastInfoBg = UIColor(named: "toastInfoBg")!
    }

//    struct Habit {
//        // mirrors the default Habit.frequencyPerWeek attribute in DataModel.xcdatamodel
//        static let defaultFrequencyPerWeek = 1
//    }

    public enum SortDir: String {
        case asc, desc
    }
}
