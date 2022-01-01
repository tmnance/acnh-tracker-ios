//
//  InsectDetail.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 12/30/21.
//

import SwiftUI
import PDFKit

struct InsectDetail: View {
    @State private var zooming: Bool = false
    @Environment(\.dismiss) var dismiss
    let insect: Insect
    let isDonated = false

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

//            AsyncImage(url: URL(string: insect.image)) { image in
//                image.resizable()
//            } placeholder: {
//                ProgressView()
//            }
//            .scaledToFit()

            VStack(spacing: 0) {
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

                Text("**Location:** \(insect.location)")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.bottom, 10)
//
//                Text("**Fake if…** \(insect.fake)")
//                    .font(.system(size: 18))
//                    .foregroundColor(.gray)
//                    .frame(maxWidth: .infinity, alignment: .leading)
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
