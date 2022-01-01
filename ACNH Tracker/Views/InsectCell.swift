//
//  InsectCell.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import SwiftUI

struct InsectCell: View {
    @Environment(\.managedObjectContext) private var viewContext

    private let minHeight = 160.0

    @State var insect: Insect
    let onTap: () -> Void

    private func getBgColor(_ insect: Insect) -> Color {
        return (insect.isDonated ?
            Color(red: 0.8, green: 1, blue: 0.8) :
            insect.isObtained ?
                Color(red: 1, green: 1, blue: 0.8) :
                Color(red: 0.8, green: 0.8, blue: 0.8)
        ).opacity(0.7)
    }

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

//            HStack(spacing: 1) {
//                ForEach((0...11), id: \.self) {
//                    Rectangle()
//                        .fill($0 % 2 == 0 ? .gray : .green)
//                        .frame(height: 20)
//                }
//            }
            HStack(spacing: 6) {
                Text("🗓")
                    .font(.system(size: 14))
                MonthAvailability(monthsAvailable: insect.monthsNorthern)
//                    .padding(.horizontal, 1)
//                    .padding(.leading, 30)
            }
            .padding(.horizontal, 6)

            Spacer()
                .frame(maxWidth: .infinity)

            HStack {
                HStack {
                    Text("🎒")
                        .font(.system(size: 24))
                        .frame(minWidth: 0)
                    Toggle("", isOn: $insect.isObtained)
                        .labelsHidden()
                        .frame(minWidth: 0)
                        .onChange(of: insect.isObtained) { value in
                            // action...
                            print("toggle clicked! \(value)")
                            if value {
                                print("toggle -> obtainItem()");
                                insect.obtainItem()
                            } else {
                                print("toggle -> unobtainItem()");
                                insect.unobtainItem()
                            }
                        }
                }
                .padding(5)
                .background(self.getBgColor(insect))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    Text("🦉")
                        .font(.system(size: 24))
                        .frame(minWidth: 0)
                    Toggle("", isOn: $insect.isDonated)
                        .labelsHidden()
                        .frame(minWidth: 0)
                        .onChange(of: insect.isDonated) { value in
                            // action...
                            print("toggle clicked! \(value)")
                            if value {
                                print("toggle -> donateItem()");
                                insect.donateItem()
                            } else {
                                print("toggle -> undonateItem()");
                                insect.undonateItem()
                            }
                        }
                }
                .padding(5)
                .background(self.getBgColor(insect))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .frame(height: minHeight)
        .background(
            GeometryReader { geo in
                Image(uiImage: UIImage(named: "Insect/\(insect.imageName)") ?? UIImage())
                    .resizable()
                    .frame(width: geo.size.width, height: geo.size.width, alignment: .center)
                    .scaledToFill()
                    .clipped()
                    .scaleEffect(0.5)
//                AsyncImage(url: URL(string: insect.image)) { image in
//                    image.resizable()
//                } placeholder: {
//                    ProgressView()
//                }
//                .frame(width: geo.size.width, height: geo.size.width, alignment: .center)
//                .scaledToFill()
//                .clipped()
            }
            .onTapGesture {
                onTap()
            }
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
        InsectCell(insect: Insect.sample) {}
    }
}
