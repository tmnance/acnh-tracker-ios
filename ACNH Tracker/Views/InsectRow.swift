//
//  InsectRow.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 1/15/22.
//

import SwiftUI

struct InsectRow: View {
    private let minHeight = 60.0

    @ObservedObject var insect: Insect
    let onTap: () -> Void

    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: "Insect/\(insect.imageName)") ?? UIImage())
                .resizable()
                .scaledToFit()
                .brightness(insect.isObtained ? 0 : -1)
                .padding(.leading, 6)


            Text("**\(insect.name.capitalized)**")
                .font(.system(size: 14))

            Spacer()
            
            HStack(spacing: 6) {
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
                
                HStack(spacing: 0) {
                    Image(uiImage: UIImage(named: "donate") ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Constants.Colors.donateIconFill)
                        .frame(height: 26)
                        .padding(.trailing, 3)
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
            .padding(.trailing, 6)
            .frame(width: 185)
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
            Image(uiImage: UIImage(named: "background") ?? UIImage())
                .resizable(resizingMode: .tile)
        )
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .foregroundColor(Constants.Colors.getStatusBorderColor(
                    isObtained: insect.isObtained,
                    isDonated: insect.isDonated
                ))
        )
    }
}

struct InsectRow_Previews: PreviewProvider {
    static var previews: some View {
        InsectRow(insect: Insect.sample) {}
    }
}
