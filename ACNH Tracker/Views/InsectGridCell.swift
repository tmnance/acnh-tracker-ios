//
//  InsectGridCell.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import SwiftUI

struct InsectGridCell: View {
    private let minHeight = 160.0

    @ObservedObject var insect: Insect
    let onTap: () -> Void

    // TODO: refactor to shared fn
    private func getBgColor(_ insect: Insect) -> Color {
        return (insect.isDonated ?
            Color(red: 0.8, green: 1, blue: 0.8) :
            insect.isObtained ?
                Color(red: 1, green: 1, blue: 0.8) :
                Color(red: 0.8, green: 0.8, blue: 0.8)
        ).opacity(0.7)
    }

    // TODO: refactor to shared fn
    private func getBgColor2(_ insect: Insect) -> Color {
        return insect.isDonated ?
            .green :
            insect.isObtained ?
                .yellow :
                .gray
    }

    var body: some View {
        VStack {
            Text("**\(insect.name.capitalized)**")
                .font(.system(size: 14))
                .frame(maxWidth: .infinity)
                .padding(5)
                .background(self.getBgColor(insect))

            Spacer()
                .frame(maxWidth: .infinity)

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
            .onTapGesture {
                // do nothing
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            onTap()
        }
        .frame(height: minHeight)
        .background(
            Image(uiImage: UIImage(named: "Insect/\(insect.imageName)") ?? UIImage())
                .resizable()
                .scaledToFit()
                .brightness(insect.isObtained ? 0 : -1)
                .scaleEffect(0.6)
        )
        .background(
            Image(uiImage: UIImage(named: "background") ?? UIImage())
                .resizable(resizingMode: .tile)
        )
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .foregroundColor(self.getBgColor2(insect))
        )
    }
}

struct InsectCell_Previews: PreviewProvider {
    static var previews: some View {
        InsectGridCell(insect: Insect.sample) {}
    }
}
