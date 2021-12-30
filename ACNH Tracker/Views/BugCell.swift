//
//  BugCell.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import SwiftUI

struct BugCell: View {
    @Environment(\.managedObjectContext) private var viewContext

    private let imageWidth = 130.0
    private let minHeight = 160.0

    @State var bug: Bug
    let onTap: () -> Void

    private func getBgColor(_ bug: Bug) -> Color {
        return (bug.isDonated ?
            Color(red: 0.8, green: 1, blue: 0.8) :
            bug.isObtained ?
                Color(red: 1, green: 1, blue: 0.8) :
                Color(red: 0.8, green: 0.8, blue: 0.8)
        ).opacity(0.7)
    }

    private func getBgColor2(_ bug: Bug) -> Color {
        return bug.isDonated ?
            .green :
            bug.isObtained ?
                .yellow :
                .gray
    }

    var body: some View {
        VStack {
            Text("**\(bug.name.capitalized)**")
                .font(.system(size: 16))
                .frame(maxWidth: .infinity)
                .padding(5)
                .background(self.getBgColor(bug))

            Spacer()
                .frame(maxWidth: .infinity)

            HStack {
                HStack {
                    Text("🎒")
                        .font(.system(size: 24))
//                        .foregroundColor(self.getBgColor2(bug))
                        .frame(minWidth: 0)
                    Toggle("", isOn: $bug.isObtained)
                        .labelsHidden()
                        .frame(minWidth: 0)
                        .onChange(of: bug.isObtained) { value in
                            // action...
                            print("toggle clicked! \(value)")
                            if value {
                                print("toggle -> obtainItem()");
                                bug.obtainItem()
                            } else {
                                print("toggle -> unobtainItem()");
                                bug.unobtainItem()
                            }
                        }
                }
                .padding(5)
                .background(self.getBgColor(bug))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: .trailing)

                HStack {
                    Text("🦉")
                        .font(.system(size: 24))
//                        .foregroundColor(self.getBgColor2(bug))
                        .frame(minWidth: 0)
                    Toggle("", isOn: $bug.isDonated)
                        .labelsHidden()
                        .frame(minWidth: 0)
                        .onChange(of: bug.isDonated) { value in
                            // action...
                            print("toggle clicked! \(value)")
                            if value {
                                print("toggle -> donateItem()");
                                bug.donateItem()
                            } else {
                                print("toggle -> undonateItem()");
                                bug.undonateItem()
                            }
                        }
                }
                .padding(5)
                .background(self.getBgColor(bug))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .frame(height: minHeight)
        .background(
            GeometryReader { geo in
                AsyncImage(url: URL(string: bug.image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: geo.size.width, height: geo.size.width, alignment: .center)
                .scaledToFill()
                .clipped()
            }
            .onTapGesture {
                onTap()
            }
        )
        .cornerRadius(10)
        .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .foregroundColor(self.getBgColor2(bug))
            )
    }
}

struct BugCell_Previews: PreviewProvider {
    static var previews: some View {
        BugCell(bug: Bug.sample) {}
    }
}
