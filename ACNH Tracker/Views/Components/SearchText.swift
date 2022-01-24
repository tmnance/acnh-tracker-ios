//
//  SearchText.swift
//  ACNH Tracker
//
//  Created by Tim Nance on 1/14/22.
//

import SwiftUI

struct SearchText: View {
    @Environment(\.colorScheme) var colorScheme
    var placeholder: String
    @Binding var text: String

    var backgroundColor: Color {
      if colorScheme == .dark {
           return Color(.systemGray5)
       } else {
           return Color(.systemGray6)
       }
    }

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.secondary)
            TextField(placeholder, text: $text)
            if text != "" {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.medium)
                    .foregroundColor(Color(.systemGray))
                    .padding(.leading, 3)
                    .onTapGesture {
                        withAnimation {
                            self.text = ""
                          }
                    }
            }
        }
        .padding(8)
        .background(backgroundColor)
        .cornerRadius(12)
    }
}

struct SearchText_Previews: PreviewProvider {
    @State static private var searchText = ""

    static var previews: some View {
        SearchText(placeholder: "Search", text: $searchText)
    }
}
