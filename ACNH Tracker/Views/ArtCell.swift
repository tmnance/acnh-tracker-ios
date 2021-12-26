//
//  ArtCell.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 11/22/21.
//

import SwiftUI

struct ArtCell: View {
    @Environment(\.managedObjectContext) private var viewContext

    private let imageWidth = 130.0
    private let minHeight = 160.0

    @State var art: Art
    let onTap: () -> Void

//    @State private var isDonated: Bool = false

    var body: some View {
        VStack {
            Text("**\(art.shortName.capitalized)**")
                .font(.system(size: 16))
//                .lineLimit(1)
//                .allowsTightening(true)
//                .truncationMode(.middle)
                .frame(maxWidth: .infinity)
                .padding(5)
                .background((art.isDonated ? Color(red: 0.8, green: 1, blue: 0.8) : Color(red: 0.8, green: 0.8, blue: 0.8)).opacity(0.7))
//                Text("*\(art.artist)*")
//                    .font(.system(size: 18))
//                    .foregroundColor(.gray)

            Spacer()
                .frame(maxWidth: .infinity)

            HStack {
                Text("🦉")
                    .font(.system(size: 24))
                    .foregroundColor(art.isDonated ? .green : .gray)
                    .frame(minWidth: 0)
                Toggle("", isOn: $art.isDonated)
                    .labelsHidden()
                    .frame(minWidth: 0)
                    .onChange(of: art.isDonated) { value in
                        // action...
                        print("toggle clicked! \(value)")
                        if value {
                            print("toggle -> obtainItem()");
                            art.obtainItem()
                        } else {
                            print("toggle -> unobtainItem()");
                            art.unobtainItem()
                        }
                    }
            }
            .padding(5)
            .background((art.isDonated ? Color(red: 0.8, green: 1, blue: 0.8) : Color(red: 0.8, green: 0.8, blue: 0.8)).opacity(0.7))
            .cornerRadius(10)
            .frame(maxWidth: .infinity, alignment: .trailing)
//            .frame(maxWidth: .infinity)
//            .padding(5)
//            .background((art.isDonated ? Color(red: 0.8, green: 1, blue: 0.8) : Color(red: 0.8, green: 0.8, blue: 0.8)).opacity(0.7))
        }
        .frame(height: minHeight)
        .background(
            GeometryReader { geo in
                Image(uiImage: UIImage(named: "Art/\(art.imageName)") ?? UIImage())
                    .resizable()
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
                    .foregroundColor(art.isDonated ? .green : .gray)
            )
    }
    
    private func unobtainItem(obtainedItem: ObtainedItem) {
        viewContext.delete(obtainedItem)
        do {
            try viewContext.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
}

struct ArtCell_Previews: PreviewProvider {
    static var previews: some View {
        ArtCell(art: Art.sample) {}
    }
}
