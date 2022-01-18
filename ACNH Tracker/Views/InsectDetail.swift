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

    // TODO: refactor to shared fn
    private func getBgColor(_ insect: Insect) -> Color {
        return (insect.isDonated ?
            Color(red: 0.8, green: 1, blue: 0.8) :
            insect.isObtained ?
                Color(red: 1, green: 1, blue: 0.8) :
                Color(red: 0.8, green: 0.8, blue: 0.8)
        ).opacity(0.7)
    }

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

            VStack(spacing: 0) {
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
                    .background(self.getBgColor(insect))
                    .cornerRadius(10)

                    Spacer()

                    HStack {
                        Image(uiImage: UIImage(named: "donate") ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(red: 102/255, green: 102/255,blue: 102/255))
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
                    .padding(.trailing, 10)
                    .background(self.getBgColor(insect))
                    .cornerRadius(10)
                }
                .padding(.bottom, 10)

                Group {
                    Text("**Caught:** ")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                    + Text(insect.isObtained ? "Yes" : "No")
                        .font(.system(size: 18))
                        .foregroundColor(insect.isObtained ? .green : .gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)

                Group {
                    Text("**Donated:** ")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                    + Text(insect.isDonated ? "Yes" : "No")
                        .font(.system(size: 18))
                        .foregroundColor(insect.isDonated ? .green : .gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)

                Text("**Rarity:** \(insect.rarity.ucFirst())")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)

                if insect.totalCatchesToUnlock > 0 {
                    Text("**Total insect catches to unlock:** \(insect.totalCatchesToUnlock)")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                }

                Text("**Location:** \(insect.location.ucFirst())")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)

                Text("**Weather:** \(insect.weather.ucFirst())")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)

//                HStack(spacing: 6) {
//                    Text("**Seasonality:**")
//                        .font(.system(size: 18))
//                        .foregroundColor(.gray)
//                    MonthAvailability(monthsAvailable: insect.monthsNorthern)
//                }
//                .padding(.bottom, 10)
                VStack(spacing: 6) {
                    Text("**Seasonality:**")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    MonthAvailability(monthsAvailable: insect.monthsNorthern)
                        .padding(.horizontal, 10)
                }
                .padding(.bottom, 10)

//                HStack(spacing: 6) {
//                    Text("**Active Hours:**")
//                        .font(.system(size: 18))
//                        .foregroundColor(.gray)
//                    ActiveHours(hoursActive: insect.hours, monthsAvailable: insect.monthsNorthern)
//                }
//                .padding(.bottom, 10)
                VStack(spacing: 6) {
                    Text("**Active Hours:**")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ActiveHours(hoursActive: insect.hours, monthsAvailable: insect.monthsNorthern)
                        .padding(.horizontal, 10)
                }
                .padding(.bottom, 10)
            }
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
