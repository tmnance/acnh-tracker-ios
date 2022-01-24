//
//  ArtDetailsView.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 11/26/21.
//

import SwiftUI
import PDFKit

struct ArtDetailsView: View {
    @State private var zooming: Bool = false
    @Environment(\.dismiss) var dismiss
    let art: Art
    let isDonated = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("**\(art.name.capitalized)**")
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

            Image(uiImage: UIImage(named: "Art/\(art.imageName)") ?? UIImage())
                .resizable()
                .scaledToFit()

            VStack(spacing: 0) {
                Group {
                    Text("**Donated:** ")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                    + Text(art.isDonated ? "Yes" : "No")
                        .font(.system(size: 18))
                        .foregroundColor(art.isDonated ? .green : .gray)
                }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)

                Text("**Real name:** \(art.realName)")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)

                Text("**Artist:** \(art.artist)")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)

                Text("**Fake if…** \(art.fake)")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)

            Spacer()
                .frame(maxHeight: .infinity)
        }
    }
}

struct ArtDetail_Previews: PreviewProvider {
    static var previews: some View {
        ArtDetailsView(art: Art.sample)
    }
}
