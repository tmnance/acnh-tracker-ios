//
//  InsectDetail.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import SwiftUI
import PDFKit

struct InsectDetail: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var insect: Insect

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("**\(insect.name.capitalized)**")
                    .font(.system(size: 24))
                Spacer()
                Button(action: {
                    withAnimation {
                        dismiss()
                    }
                }) {
                    ZStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(Color(UIColor.secondarySystemFill))
                            .font(.system(size: 31))
                        Image(systemName: "xmark")
                            .foregroundColor(Color.secondary)
                            .font(.system(size: 15, weight: .bold))
                    }
                }
            }
            .padding(10)

            Divider()
                .padding(.bottom, 10)

            Image(uiImage: UIImage(named: "Insect/\(insect.imageName)") ?? UIImage())
                .resizable()
                .scaledToFit()
                .brightness(insect.isObtained ? 0 : -1)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    HStack(spacing: 0) {
                        Image(uiImage: UIImage(named: "catch") ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .frame(height: 26)
                        Toggle("", isOn: $insect.isObtained)
                            .labelsHidden()
                            .frame(minWidth: 0)
                            .onChange(of: insect.isObtained) { value in
                                if value {
                                    insect.obtainItem()
                                } else {
                                    insect.unobtainItem()
                                }
                            }
                    }
                    .padding(5)
                    .background(Constants.Colors.getStatusBgColor(
                        isObtained: insect.isObtained,
                        isDonated: insect.isDonated
                    ))
                    .cornerRadius(10)

                    Spacer()

                    HStack {
                        Image(uiImage: UIImage(named: "donate") ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Constants.Colors.donateIconFill)
                            .frame(height: 26)
                            .padding(.trailing, 5)
                        Toggle("", isOn: $insect.isDonated)
                            .labelsHidden()
                            .frame(minWidth: 0)
                            .onChange(of: insect.isDonated) { value in
                                if value {
                                    insect.donateItem()
                                } else {
                                    insect.undonateItem()
                                }
                            }
                    }
                    .padding(5)
                    .background(Constants.Colors.getStatusBgColor(
                        isObtained: insect.isObtained,
                        isDonated: insect.isDonated
                    ))
                    .cornerRadius(10)
                }

                Group {
                    Text("**Caught:** ")
                    + Text(insect.isObtained ? "Yes" : "No")
                        .foregroundColor(insect.isObtained ?
                            Constants.Colors.statusCompleteText :
                            Constants.Colors.statusIncompleteText
                        )
                }

                Group {
                    Text("**Donated:** ")
                    + Text(insect.isDonated ? "Yes" : "No")
                        .foregroundColor(insect.isDonated ?
                            Constants.Colors.statusCompleteText :
                            Constants.Colors.statusIncompleteText
                        )
                }

                Text("**Rarity:** \(insect.rarity.ucFirst())")

                if insect.totalCatchesToUnlock > 0 {
                    Text("**Total insect catches to unlock:** \(insect.totalCatchesToUnlock)")
                }

                Text("**Location:** \(insect.location.ucFirst())")

                Text("**Weather:** \(insect.weather.ucFirst())")

                VStack(alignment: .leading, spacing: 6) {
                    Text("**Seasonality:**")
                    MonthAvailability(monthsAvailable: insect.monthsNorthern)
                        .padding(.horizontal, 10)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("**Active Hours:**")
                    ActiveHours(hoursActive: insect.hours, monthsAvailable: insect.monthsNorthern)
                        .padding(.horizontal, 10)
                }
            }
            .font(.system(size: 18))
            .foregroundColor(Constants.Colors.primaryText)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)

            Spacer()
                .frame(maxHeight: .infinity)
        }
    }
}

struct InsectDetail_Previews: PreviewProvider {
    static var previews: some View {
        InsectDetail(insect: Insect.sample)
    }
}
